import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/currency_widget_title_extension.dart';
import 'package:asset_tracker/core/constants/global/general_constants.dart';
import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/domain/entities/database/alarm_entity.dart';
import 'package:asset_tracker/domain/usecase/database/database_use_case.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/common/custom_dropdown_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/edit_alarm_popup_widget.dart';
import 'package:asset_tracker/presentation/view_model/home/alarm/alarm_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class AlarmView extends ConsumerStatefulWidget {
  const AlarmView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlarmViewState();
}

class _AlarmViewState extends ConsumerState<AlarmView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(tradeViewModelProvider).getCurrencyList(ref);
      // Sadece currency code boş değilse set et
      // ref.read(tradeViewModelProvider).getPriceSelectedCurrency(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(alarmViewModelProvider);

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: 50,
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.grey.shade300,
              labelColor: DefaultColorPalette.mainBlue,
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: DefaultColorPalette.mainBlue,
              tabs: const [
                Tab(text: 'Alarm Kur'),
                Tab(text: 'Alarmlarım'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNewAlarmForm(viewModel),
                _buildInactiveAlarms(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveAlarms() {
    List<AlarmEntity>? alarms = [];
    alarms = ref.watch(appGlobalProvider).getUserData?.userAlarmList;
    return _buildAlarmsList(alarms);
  }

  Widget _buildNewAlarmForm(AlarmViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _buildAssetSelector(ref),

          const SizedBox(height: 24),

          // Alarm Tipi
          _buildSectionTitle('Alarm Tipi'),
          const SizedBox(height: 12),
          _buildAlarmTypeSelector(),

          const SizedBox(height: 24),
          // // Alarm Nedeni
          _buildSectionTitle('Alarm Nedeni'),
          const SizedBox(height: 12),
          _buildOrderTypeSelector(),
          // // Koşul ve Değer
          // _buildSectionTitle('Koşul'),
          // const SizedBox(height: 12),
          // _buildConditionSelector(),

          const SizedBox(height: 16),
          _buildValueInput(viewModel),

          const SizedBox(height: 24),

          // // Alarm Nedeni
          // _buildSectionTitle('Alarm Nedeni'),
          // const SizedBox(height: 12),
          // _buildOrderTypeSelector(),

          // // Koşul ve Değer
          _buildSectionTitle('Koşul'),
          const SizedBox(height: 12),
          _buildConditionSelector(),
          const SizedBox(height: 12),
          CreateAlarmInfoWidget(ref: ref),
          const SizedBox(height: 32),

          // Kurma Butonu
          _buildCreateAlarmButton(),
        ],
      ),
    );
  }

  Widget _buildAlarmsList(List<AlarmEntity>? alarms) {
    if (alarms == null || alarms.isEmpty) {
      return _buildEmptyState('Alarm bulunmuyor');
    }

    // Alarmları sırala
    final sortedAlarms = _sortAlarmsDetailed();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedAlarms.length,
      itemBuilder: (context, index) {
        final alarm = sortedAlarms[index];
        return _buildAlarmCard(alarm);
      },
    );
  }

  List<AlarmEntity> _sortAlarmsDetailed() {
    final List<AlarmEntity>? sortedAlarms =
        ref.watch(appGlobalProvider).getUserData?.userAlarmList;

    sortedAlarms?.sort((a, b) {
      // 1. Önce aktif/deaktif durumuna göre sırala
      if (a.isTriggered != b.isTriggered) {
        return a.isTriggered ? 1 : -1; // Aktif olanlar önce
      }

      // 2. Aynı durumda olanları tarihlerine göre sırala
      if (!a.isTriggered) {
        // Aktif alarmlar: en yakın tarih önce
        return a.createTime.compareTo(b.createTime);
      } else {
        // Deaktif alarmlar: en yeni tarih önce
        return b.createTime.compareTo(a.createTime);
      }
    });

    return sortedAlarms ?? [];
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmCard(AlarmEntity alarm) {
    final String title = alarm.currencyCode.getCurrencyTitle();
    bool isActive = !alarm.isTriggered;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: DefaultColorPalette.mainBlue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    title.substring(0, 2),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
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
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF2C3E50),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      alarm.type == AlarmOrderType.BUY
                          ? ref
                              .read(appGlobalProvider)
                              .getSelectedCurrencySellPrice(alarm.currencyCode)
                              .toString()
                          : ref
                              .read(appGlobalProvider)
                              .getSelectedCurrencyBuyPrice(alarm.currencyCode)
                              .toString(),
                      style: const TextStyle(
                        color: Color(0xFF7F8C8D),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isActive,
                onChanged: (value) async {
                  ref.read(appGlobalProvider).updateSingleUserAlarm(
                      alarm.copyWith(isTriggered: !alarm.isTriggered));
                  final a =
                      await getIt<DatabaseUseCase>().toggleAlarmStatus(alarm);
                  a.fold(
                      (failure) => debugPrint("FAIL FAIL${failure.message}"),
                      (success) => EasySnackBar.show(
                          context,
                          alarm.isTriggered
                              ? "Alarmınız aktif edildi"
                              : "Alarmınız deaktif edildi"));
                },
                activeColor: DefaultColorPalette.mainBlue,
                inactiveThumbColor: Colors.grey[400],
                inactiveTrackColor: Colors.grey[200],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Koşul:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      _getConditionText(alarm),
                      style: const TextStyle(
                        color: Color(0xFF2C3E50),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hedef:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '₺${alarm.targetValue}',
                      style: const TextStyle(
                        color: Color(0xFF2C3E50),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Emir Tipi:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: alarm.type == AlarmOrderType.BUY.name
                            ? Colors.green[100]
                            : Colors.red[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        alarm.type == AlarmOrderType.BUY.name
                            ? 'Alış'
                            : 'Satış',
                        style: TextStyle(
                          color: alarm.type == AlarmOrderType.BUY.name
                              ? Colors.green[700]
                              : Colors.red[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                GeneralConstants.dateFormat.format(alarm.createTime),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      _showEditAlarmPopup(context, alarm);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                    child: Text(
                      'Düzenle',
                      style: TextStyle(
                        color: DefaultColorPalette.mainBlue,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Alarm silme
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                    child: Text(
                      'Sil',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditAlarmPopup(BuildContext context, AlarmEntity alarm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditAlarmPopup(
        alarm: alarm,
        onSave: (updatedAlarm) {
          // Alarmı güncelle
          ref.read(appGlobalProvider).updateSingleUserAlarm(updatedAlarm);

          // Veritabanında güncelle
          // getIt<DatabaseUseCase>().updateAlarm(updatedAlarm).then((result) {
          //   result.fold(
          //     (failure) => debugPrint("Update failed: ${failure.message}"),
          //     (success) => EasySnackBar.show(
          //       context,
          //       "Alarm başarıyla güncellendi",
          //     ),
          //   );
          // });
        },
      ),
    );
  }

  String _getConditionText(AlarmEntity alarm) {
    String conditionText = '';

    if (alarm.mode == AlarmType.PERCENT.name) {
      conditionText = alarm.direction == AlarmCondition.UP.name
          ? '%${alarm.targetValue} yükselse'
          : '%${alarm.targetValue} düşse';
    } else {
      conditionText = alarm.direction == AlarmCondition.UP.name
          ? '₺${alarm.targetValue} üstüne çıksa'
          : '₺${alarm.targetValue} altına inse';
    }

    return conditionText;
  }

  // Alarm kurma form widget'ları
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF2C3E50),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildAssetSelector(WidgetRef ref) {
    return CustomDropDownWidget(
      pageCurrency: null,
      viewModel: ref.read(alarmViewModelProvider),
    );
  }

  Widget _buildAlarmTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
                'Fiyat',
                ref.watch(alarmViewModelProvider).selectedAlarmType ==
                    AlarmType.PRICE,
                () => ref
                    .read(alarmViewModelProvider)
                    .toggleTypes(AlarmType.PRICE, ref)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildToggleButton(
              'Yüzdesel Fark',
              ref.watch(alarmViewModelProvider).selectedAlarmType ==
                  AlarmType.PERCENT,
              () => ref
                  .watch(alarmViewModelProvider)
                  .toggleTypes(AlarmType.PERCENT, ref),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
                ref.watch(alarmViewModelProvider).selectedAlarmType ==
                        AlarmType.PERCENT
                    ? 'Yükselse'
                    : 'Üstüne Çıksa',
                ref.watch(alarmViewModelProvider).selectedCondition ==
                    AlarmCondition.UP,
                () => ref
                    .read(alarmViewModelProvider)
                    .toggleTypes(AlarmCondition.UP, ref)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildToggleButton(
                ref.watch(alarmViewModelProvider).selectedAlarmType ==
                        AlarmType.PERCENT
                    ? 'Düşse'
                    : 'Altına İnse',
                ref.read(alarmViewModelProvider).selectedCondition ==
                    AlarmCondition.DOWN,
                () => ref
                    .read(alarmViewModelProvider)
                    .toggleTypes(AlarmCondition.DOWN, ref)),
          ),
        ],
      ),
    );
  }

  Widget _buildValueInput(AlarmViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: TextField(
        controller: viewModel.valueController,
        style: const TextStyle(color: Color(0xFF2C3E50), fontSize: 15),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          viewModel.changeFormText(value);
        },
        decoration: InputDecoration(
          hintText: viewModel.selectedAlarmType == AlarmType.PERCENT
              ? '%5.0'
              : '₺35,000',
          hintStyle: const TextStyle(color: Color(0xFF7F8C8D)),
          prefixIcon: Icon(
            viewModel.selectedAlarmType == AlarmType.PERCENT
                ? Icons.percent
                : Icons.currency_lira,
            color: DefaultColorPalette.mainBlue,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildOrderTypeSelector() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                    'Alış Emri',
                    ref.watch(alarmViewModelProvider).selectedOrderType ==
                        AlarmOrderType.BUY,
                    () => ref
                        .watch(alarmViewModelProvider)
                        .toggleTypes(AlarmOrderType.BUY, ref)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildToggleButton(
                    'Satış Emri',
                    ref.watch(alarmViewModelProvider).selectedOrderType ==
                        AlarmOrderType.SELL,
                    () => ref
                        .watch(alarmViewModelProvider)
                        .toggleTypes(AlarmOrderType.SELL, ref)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color.fromRGBO(25, 127, 229, 0.05),
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: Color.fromRGBO(25, 127, 229, 0.1), width: 1),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: DefaultColorPalette.mainBlue,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ref.watch(alarmViewModelProvider).selectedOrderType ==
                          AlarmOrderType.BUY
                      ? 'Alış emri: Satış fiyatından hesaplanır'
                      : 'Satış emri: Alış fiyatından hesaplanır',
                  style: const TextStyle(
                    color: Color(0xFF2C3E50),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromRGBO(25, 127, 229, 1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF7F8C8D),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateAlarmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          await ref.read(alarmViewModelProvider).saveAlarm(context, ref);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: DefaultColorPalette.mainBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Alarm Kur',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class CreateAlarmInfoWidget extends ConsumerWidget {
  const CreateAlarmInfoWidget({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(alarmViewModelProvider);
    final orderType = viewModel.selectedOrderType;
    final alarmType = viewModel.selectedAlarmType;
    final alarmCondition = viewModel.selectedCondition;

    // Dinamik metin oluşturma
    String getAlarmText() {
      String currencyPair =
          viewModel.selectedCurrency; // Bu değer viewModel'den alınabilir
      String priceValue = viewModel.selectedCurrencyPrice.toString();
      String percentValue = viewModel.selectedCurrencyPercent.toString();

      String orderTypeText = orderType == AlarmOrderType.BUY ? "alış" : "satış";
      String priceTypeText = orderType == AlarmOrderType.BUY ? "satış" : "alış";

      if (alarmType == AlarmType.PRICE) {
        String conditionText = alarmCondition == AlarmCondition.DOWN
            ? "altına düştüğü"
            : "üstüne çıktığı";
        return "$currencyPair $orderTypeText fiyatı $priceValue $conditionText anda bildirim gönderilecek";
      } else {
        // PERCENT
        String conditionText =
            alarmCondition == AlarmCondition.DOWN ? "düştüğü" : "yükseldiği";
        return "$currencyPair $orderTypeText fiyatı yüzde $percentValue $conditionText anda bildirim gönderilecek";
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(25, 127, 229, 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color.fromRGBO(25, 127, 229, 0.1), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: DefaultColorPalette.mainBlue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              getAlarmText(),
              style: const TextStyle(
                color: Color(0xFF2C3E50),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
