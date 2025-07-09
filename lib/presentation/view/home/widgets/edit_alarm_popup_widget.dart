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

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _targetValueController =
        TextEditingController(text: widget.alarm.targetValue.toString());
    _selectedOrderType = widget.alarm.type;
    _selectedConditionType = widget.alarm.direction; // Assuming this exists

    _targetValueController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _targetValueController.dispose();
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
      });
    }
  }

  void _handleSave() {
    if (!_hasChanges) {
      Navigator.pop(context);
      return;
    }

    final newTargetValue = double.tryParse(_targetValueController.text) ?? 0.0;
    if (newTargetValue <= 0) {
      return;
    }

    final updatedAlarm = widget.alarm.copyWith(
      targetValue: newTargetValue,
      type: _selectedOrderType,
      direction: _selectedConditionType,
    );

    widget.onSave(updatedAlarm);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currencyTitle =
        widget.alarm.currencyCode.toString().getCurrencyTitle();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(24),
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
                      currencyTitle.substring(0, 2),
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
                  onPressed: () => Navigator.pop(context),
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
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: TextFormField(
                controller: _targetValueController,
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
                  hintText: widget.alarm.targetValue.toString(),
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
                      onPressed: () => Navigator.pop(context),
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
                        colors: _hasChanges
                            ? [
                                DefaultColorPalette.mainBlue,
                                DefaultColorPalette.mainBlue.withOpacity(0.8)
                              ]
                            : [Colors.grey[300]!, Colors.grey[300]!],
                      ),
                    ),
                    child: TextButton(
                      onPressed: _handleSave,
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _hasChanges ? 'Kaydet' : 'Değişiklik Yok',
                        style: TextStyle(
                          color: _hasChanges ? Colors.white : Colors.grey[600],
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
    );
  }

  Widget _buildConditionButton(
      String text, AlarmCondition type, IconData icon, Color color) {
    final isSelected = (_selectedConditionType.name == type.name);
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedConditionType = type;
        });
        _checkForChanges();
      },
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
    );
  }

  Widget _buildOrderTypeButton(String text, AlarmOrderType type, Color color) {
    final isSelected = _selectedOrderType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOrderType = type;
        });
        _checkForChanges();
      },
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
    );
  }
}
