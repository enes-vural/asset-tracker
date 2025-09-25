import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/currency_widget_title_extension.dart';
import 'package:asset_tracker/domain/entities/database/alarm_entity.dart';
import 'package:asset_tracker/presentation/view_model/home/alarm/alarm_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditAlarmPopup extends StatefulWidget {
  final AlarmEntity alarm;
  final Function(AlarmEntity) onSave;

  const EditAlarmPopup({
    super.key,
    required this.alarm,
    required this.onSave,
  });

  @override
  State<EditAlarmPopup> createState() => _EditAlarmPopupState();
}

class _EditAlarmPopupState extends State<EditAlarmPopup> {
  late TextEditingController _targetValueController;
  late AlarmOrderType _selectedOrderType;
  late AlarmCondition _selectedConditionType;
  late FocusNode _textFieldFocusNode;

  bool _hasChanges = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _targetValueController =
        TextEditingController(text: widget.alarm.targetValue.toString());
    _selectedOrderType = widget.alarm.type;
    _selectedConditionType = widget.alarm.direction;
    _textFieldFocusNode = FocusNode();

    _targetValueController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _targetValueController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final newTargetValue = double.tryParse(_targetValueController.text) ?? 0.0;
    final hasChanges = newTargetValue != widget.alarm.targetValue ||
        _selectedOrderType != widget.alarm.type ||
        _selectedConditionType != widget.alarm.direction;

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
        _errorMessage = null; // Clear error when user makes changes
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_hasChanges) {
      Navigator.pop(context);
      return;
    }

    final newTargetValue = double.tryParse(_targetValueController.text) ?? 0.0;
    if (newTargetValue <= 0) {
      setState(() {
        _errorMessage = 'Hedef değer 0\'dan büyük olmalıdır';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final updatedAlarm = widget.alarm.copyWith(
        targetValue: newTargetValue,
        type: _selectedOrderType,
        direction: _selectedConditionType,
      );

      await widget.onSave(updatedAlarm);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Alarm güncellenirken bir hata oluştu';
          _isLoading = false;
        });
      }
    }
  }

  void _showDiscardChangesDialog() {
    if (!_hasChanges) {
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Değişiklikleri Kaydetmedin'),
          content: const Text('Yaptığın değişiklikler kaybolacak. Emin misin?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close popup
              },
              child: const Text('Evet, Çık'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyTitle =
        widget.alarm.currencyCode.toString().getCurrencyTitle();

    return WillPopScope(
      onWillPop: () async {
        if (_hasChanges) {
          _showDiscardChangesDialog();
          return false;
        }
        return true;
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: DefaultColorPalette.mainBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          currencyTitle.length >= 2
                              ? currencyTitle.substring(0, 2).toUpperCase()
                              : currencyTitle.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Alarmı Düzenle',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          Text(
                            currencyTitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _showDiscardChangesDialog,
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Error Message
                if (_errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.red[600], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Hedef Değer Input
                const Text(
                  'Hedef Değer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: _errorMessage != null &&
                                (double.tryParse(_targetValueController.text) ??
                                        0) <=
                                    0
                            ? Colors.red[300]!
                            : Colors.grey[200]!),
                  ),
                  child: TextFormField(
                    controller: _targetValueController,
                    focusNode: _textFieldFocusNode,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3E50),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Hedef değeri girin',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          '₺',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      suffixIcon: _targetValueController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[400]),
                              onPressed: () {
                                _targetValueController.clear();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Koşul Seçimi
                const Text(
                  'Koşul',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildConditionButton(
                          'Aşağısına İnerse',
                          AlarmCondition.DOWN,
                          Icons.trending_down,
                          Colors.red[500]!,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey[300],
                      ),
                      Expanded(
                        child: _buildConditionButton(
                          'Yukarısına Çıkarsa',
                          AlarmCondition.UP,
                          Icons.trending_up,
                          Colors.green[500]!,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Emir Tipi Seçimi
                const Text(
                  'Emir Tipi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildOrderTypeButton(
                          'Alış',
                          AlarmOrderType.BUY,
                          Colors.green[500]!,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey[300],
                      ),
                      Expanded(
                        child: _buildOrderTypeButton(
                          'Satış',
                          AlarmOrderType.SELL,
                          Colors.red[500]!,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextButton(
                          onPressed:
                              _isLoading ? null : _showDiscardChangesDialog,
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'İptal',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: _hasChanges && !_isLoading
                                ? [
                                    DefaultColorPalette.mainBlue,
                                    DefaultColorPalette.mainBlue
                                        .withOpacity(0.8)
                                  ]
                                : [Colors.grey[300]!, Colors.grey[300]!],
                          ),
                        ),
                        child: TextButton(
                          onPressed: _isLoading ? null : _handleSave,
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  _hasChanges ? 'Kaydet' : 'Değişiklik Yok',
                                  style: TextStyle(
                                    color: _hasChanges && !_isLoading
                                        ? Colors.white
                                        : Colors.grey[600],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConditionButton(
      String text, AlarmCondition type, IconData icon, Color color) {
    final isSelected = (_selectedConditionType.name == type.name);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedConditionType = type;
          });
          _checkForChanges();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? color : Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? color : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderTypeButton(String text, AlarmOrderType type, Color color) {
    final isSelected = _selectedOrderType == type;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedOrderType = type;
          });
          _checkForChanges();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? color : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
