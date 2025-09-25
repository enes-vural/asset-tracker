import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/currency_widget_title_extension.dart';
import 'package:asset_tracker/core/constants/global/general_constants.dart';
import 'package:asset_tracker/core/helpers/dialog_helper.dart';
import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/core/mixins/validation_mixin.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:asset_tracker/domain/entities/database/alarm_entity.dart';
import 'package:asset_tracker/domain/usecase/database/database_use_case.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/common/custom_dropdown_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/edit_alarm_popup_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/unauthorized_widget.dart';
import 'package:asset_tracker/presentation/view_model/home/alarm/alarm_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class AlarmView extends ConsumerStatefulWidget {
  const AlarmView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlarmViewState();
}

class _AlarmViewState extends ConsumerState<AlarmView>
    with TickerProviderStateMixin, ValidatorMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void initTabController() {
    ref.read(alarmViewModelProvider).tabController =
        TabController(length: 2, vsync: this);

    ref.read(alarmViewModelProvider).tabController.addListener(() {
      FocusScope.of(context).unfocus();
    });
  }

//   @override
//   void dispose() {
//     ref.read(alarmViewModelProvider).tabController.dispose();
//     super.dispose();
// }

  @override
  void initState() {
    super.initState();
    initTabController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(tradeViewModelProvider).getCurrencyList(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(alarmViewModelProvider);
    final isAuthorized =
        ref.watch(authGlobalProvider.select((value) => value.isUserAuthorized));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    EasyDialog.showDialogOnProcess(context, ref, alarmViewModelProvider);
    bool canPop = ref.watch(alarmViewModelProvider.select((vm) => vm.canPop));
    return isAuthorized
        ? FutureBuilder(
            future: viewModel.shouldShowNotificationCard(),
            builder: (context, snapshot) {
              final showNotificationCard = snapshot.data == true;
              return PopScope(
                canPop: canPop,
                child: Scaffold(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  body: Column(
                    children: [
                      // Notification Card
                      if (showNotificationCard) NotificationPermissionCard(),

                      // TabBar
                      Container(
                        color: theme.scaffoldBackgroundColor,
                        child: TabBar(
                          onTap: (value) {
                            //FocusScope.of(context).unfocus();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: viewModel.tabController,
                          dividerColor: Colors.transparent,
                          unselectedLabelColor: theme.textTheme.bodySmall?.color
                                  ?.withOpacity(0.6) ??
                              (isDark
                                  ? DefaultColorPalette.darkTextSecondary
                                  : DefaultColorPalette.customGrey),
                          indicatorColor: theme.colorScheme.primary,
                          tabs: [
                            Tab(text: LocaleKeys.alarm_tab_create.tr()),
                            Tab(text: LocaleKeys.alarm_tab_list.tr()),
                          ],
                        ),
                      ),

                      // TabBarView
                      Expanded(
                        child: TabBarView(
                          controller: viewModel.tabController,
                          children: [
                            // Create Alarm Tab
                            SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child:
                                  _buildNewAlarmForm(viewModel, theme, isDark),
                            ),
                            // Alarm List Tab
                            _buildSavedAlarms(theme, isDark),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : UnAuthorizedWidget(page: UnAuthorizedPage.ALARM);
  }

  Widget _buildSavedAlarms(ThemeData theme, bool isDark) {
    List<AlarmEntity>? alarms = [];
    alarms = ref.watch(appGlobalProvider).getUserData?.userAlarmList;

    if (alarms == null || alarms.isEmpty) {
      return Container(
        color: theme.scaffoldBackgroundColor,
        child:
            _buildEmptyState(LocaleKeys.alarm_list_empty.tr(), theme, isDark),
      );
    }

    // Alarmları sırala
    final sortedAlarms = _sortAlarmsDetailed();

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedAlarms.length,
        itemBuilder: (context, index) {
          final alarm = sortedAlarms[index];
          return _buildAlarmCard(alarm, theme, isDark);
        },
      ),
    );
  }

  Widget _buildNewAlarmForm(
      AlarmViewModel viewModel, ThemeData theme, bool isDark) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _buildAssetSelector(ref),

          const SizedBox(height: 24),

          // Alarm Tipi
          _buildSectionTitle(LocaleKeys.alarm_form_type.tr(), theme),
          const SizedBox(height: 12),
          _buildAlarmTypeSelector(theme, isDark),

          const SizedBox(height: 24),
          // Alarm Nedeni
          _buildSectionTitle(LocaleKeys.alarm_form_reason.tr(), theme),
          const SizedBox(height: 12),
          _buildOrderTypeSelector(theme, isDark),

          const SizedBox(height: 16),
          _buildValueInput(viewModel, theme, isDark),

          const SizedBox(height: 24),

          // Koşul
          _buildSectionTitle(LocaleKeys.alarm_form_condition.tr(), theme),
          const SizedBox(height: 12),
          _buildConditionSelector(theme, isDark),
          const SizedBox(height: 12),
          CreateAlarmInfoWidget(ref: ref),
          const SizedBox(height: 32),

          // Kurma Butonu
          _buildCreateAlarmButton(theme),
        ],
      ),
    );
  }

  Widget _buildAlarmsList(
      List<AlarmEntity>? alarms, ThemeData theme, bool isDark) {
    if (alarms == null || alarms.isEmpty) {
      return Container(
        color: theme.scaffoldBackgroundColor,
        child:
            _buildEmptyState(LocaleKeys.alarm_list_empty.tr(), theme, isDark),
      );
    }

    // Alarmları sırala
    final sortedAlarms = _sortAlarmsDetailed();

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedAlarms.length,
        itemBuilder: (context, index) {
          final alarm = sortedAlarms[index];
          return _buildAlarmCard(alarm, theme, isDark);
        },
      ),
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

  Widget _buildEmptyState(String message, ThemeData theme, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: isDark
                ? DefaultColorPalette.darkTextTertiary
                : DefaultColorPalette.customGrey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: isDark
                  ? DefaultColorPalette.darkTextSecondary
                  : DefaultColorPalette.customGrey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmCard(AlarmEntity alarm, ThemeData theme, bool isDark) {
    final String title = alarm.currencyCode.getCurrencyTitle();
    bool isActive = !alarm.isTriggered;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
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
                  color: theme.colorScheme.primary,
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
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      alarm.type == AlarmOrderType.BUY
                          ? ref
                              .read(appGlobalProvider)
                              .getSelectedCurrencyBuyPrice(alarm.currencyCode)
                              .toString()
                          : ref
                              .read(appGlobalProvider)
                              .getSelectedCurrencySellPrice(alarm.currencyCode)
                              .toString(),
                      style: TextStyle(
                        color:
                            theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.zero,
                child: Switch(
                  value: isActive,
                  onChanged: (value) async {
                    ref.read(appGlobalProvider).updateSingleUserAlarm(
                        alarm.copyWith(isTriggered: !alarm.isTriggered));
                    EasySnackBar.show(
                        context,
                        alarm.isTriggered
                            ? LocaleKeys.alarm_list_activated.tr()
                            : LocaleKeys.alarm_list_deactivated.tr());
                    final alarmState =
                        await getIt<DatabaseUseCase>().toggleAlarmStatus(alarm);
                    alarmState.fold(
                        (failure) => debugPrint("FAIL FAIL"), (success) {});
                  },
                  thumbColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.selected)) {
                      return theme.colorScheme.primary;
                    }
                    // Seçili değilse tema rengine göre beyaz veya siyah
                    return theme.brightness == Brightness.light
                        ? Colors.white
                        : Colors.black;
                  }),
                  trackColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.selected)) {
                      return theme.colorScheme.primary.withOpacity(0.5);
                    }
                    // Seçili değilse tema rengine göre açık gri veya koyu gri
                    return theme.brightness == Brightness.light
                        ? Colors.grey.shade300
                        : Colors.grey.shade700;
                  }),
                  trackOutlineColor:
                      MaterialStateProperty.all(Colors.transparent),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? DefaultColorPalette.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.alarm_list_orderType.tr(),
                      style: TextStyle(
                        color:
                            theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: alarm.type == AlarmOrderType.BUY
                            ? (isDark
                                ? DefaultColorPalette.accentGreen
                                    .withOpacity(0.2)
                                : Colors.green.withOpacity(0.1))
                            : (isDark
                                ? DefaultColorPalette.accentRed.withOpacity(0.2)
                                : Colors.red.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        alarm.type == AlarmOrderType.BUY
                            ? LocaleKeys.alarm_list_buy.tr()
                            : LocaleKeys.alarm_list_sell.tr(),
                        style: TextStyle(
                          color: alarm.type == AlarmOrderType.BUY
                              ? (isDark
                                  ? DefaultColorPalette.accentGreen
                                  : Colors.green[800])
                              : (isDark
                                  ? DefaultColorPalette.accentRed
                                  : Colors.red[800]),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const CustomSizedBox.smallGap(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.alarm_list_condition.tr(),
                      style: TextStyle(
                        color:
                            theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      _getConditionText(alarm),
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
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
                      LocaleKeys.alarm_list_target.tr(),
                      style: TextStyle(
                        color:
                            theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '₺${alarm.targetValue}',
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
               
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
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
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
                      LocaleKeys.alarm_list_edit.tr(),
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      ref.read(appGlobalProvider).removeSingleAlarm(alarm);
                      final data =
                          await getIt<DatabaseUseCase>().deleteAlarm(alarm);
                      data.fold(
                        (failure) {
                          debugPrint(failure.message);
                        },
                        (succes) {
                          if (context.mounted) {
                            EasySnackBar.show(context,
                                LocaleKeys.alarm_list_deleteSuccess.tr());
                          }
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                    child: Text(
                      LocaleKeys.alarm_list_delete.tr(),
                      style: TextStyle(
                        color: isDark
                            ? DefaultColorPalette.accentRed
                            : Colors.red[800],
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
        onSave: (updatedAlarm) async {
          // Alarmı güncelle
          await ref.read(appGlobalProvider).updateSingleUserAlarm(updatedAlarm);

          // Veritabanında güncelle
          await getIt<DatabaseUseCase>()
              .updateAlarm(updatedAlarm)
              .then((result) {
            result.fold(
                (failure) => debugPrint("Update failed: ${failure.message}"),
                (success) {
              if (context.mounted) {
                EasySnackBar.show(
                  context,
                  LocaleKeys.alarm_list_editSuccess.tr(),
                );
              }
            });
          });
        },
      ),
    );
  }

  String _getConditionText(AlarmEntity alarm) {
    String conditionText = '';

    if (alarm.mode == AlarmType.PERCENT) {
      conditionText = alarm.direction == AlarmCondition.UP
          ? LocaleKeys.alarm_form_conditionUpPercent
              .tr(namedArgs: {'value': alarm.targetValue.toString()})
          : LocaleKeys.alarm_form_conditionDownPercent
              .tr(namedArgs: {'value': alarm.targetValue.toString()});
    } else {
      conditionText = alarm.direction == AlarmCondition.UP
          ? LocaleKeys.alarm_form_conditionUpPrice
              .tr(namedArgs: {'value': alarm.targetValue.toString()})
          : LocaleKeys.alarm_form_conditionDownPrice
              .tr(namedArgs: {'value': alarm.targetValue.toString()});
    }

    return conditionText;
  }

  // Alarm kurma form widget'ları
  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: TextStyle(
        color: theme.textTheme.bodyLarge?.color,
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

  Widget _buildAlarmTypeSelector(ThemeData theme, bool isDark) {
    final selectedAlarmType =
        ref.watch(alarmViewModelProvider.select((vm) => vm.selectedAlarmType));
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
                LocaleKeys.alarm_form_price.tr(),
                selectedAlarmType == AlarmType.PRICE,
                () => ref
                    .read(alarmViewModelProvider)
                    .toggleTypes(AlarmType.PRICE, ref)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildToggleButton(
              LocaleKeys.alarm_form_percent.tr(),
              selectedAlarmType == AlarmType.PERCENT,
              () => ref
                  .read(alarmViewModelProvider)
                  .toggleTypes(AlarmType.PERCENT, ref),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionSelector(ThemeData theme, bool isDark) {
    final selectedAlarmType =
        ref.watch(alarmViewModelProvider.select((vm) => vm.selectedAlarmType));
    final selectedCondition =
        ref.watch(alarmViewModelProvider.select((vm) => vm.selectedCondition));
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
                selectedAlarmType == AlarmType.PERCENT
                    ? LocaleKeys.alarm_form_conditionUpPercent
                        .tr(namedArgs: {'value': ''})
                    : LocaleKeys.alarm_form_conditionUpPrice
                        .tr(namedArgs: {'value': ''}),
                selectedCondition == AlarmCondition.UP,
                () => ref
                    .read(alarmViewModelProvider)
                    .toggleTypes(AlarmCondition.UP, ref)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildToggleButton(
                selectedAlarmType == AlarmType.PERCENT
                    ? LocaleKeys.alarm_form_conditionDownPercent
                        .tr(namedArgs: {'value': ''})
                    : LocaleKeys.alarm_form_conditionDownPrice
                        .tr(namedArgs: {'value': ''}),
                selectedCondition == AlarmCondition.DOWN,
                () => ref
                    .read(alarmViewModelProvider)
                    .toggleTypes(AlarmCondition.DOWN, ref)),
          ),
        ],
      ),
    );
  }

  Widget _buildValueInput(
      AlarmViewModel viewModel, ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Form(
        key: formKey,
        child: TextFormField(
          validator: (value) => checkAmount(value, true),
          controller: viewModel.valueController,
          style:
              TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 15),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            viewModel.changeFormText(value);
          },
          decoration: InputDecoration(
            hintText: viewModel.selectedAlarmType == AlarmType.PERCENT
                ? LocaleKeys.alarm_form_valueHintPercent.tr()
                : LocaleKeys.alarm_form_valueHintPrice.tr(),
            hintStyle: TextStyle(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7)),
            prefixIcon: Icon(
              viewModel.selectedAlarmType == AlarmType.PERCENT
                  ? Icons.percent
                  : Icons.currency_lira,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderTypeSelector(ThemeData theme, bool isDark) {
    final selectedOrderType =
        ref.read(alarmViewModelProvider.select((vm) => vm.selectedOrderType));
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                    LocaleKeys.alarm_form_buyOrder.tr(),
                    selectedOrderType == AlarmOrderType.BUY,
                    () => ref
                        .read(alarmViewModelProvider)
                        .toggleTypes(AlarmOrderType.BUY, ref)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildToggleButton(
                    LocaleKeys.alarm_form_sellOrder.tr(),
                    selectedOrderType == AlarmOrderType.SELL,
                    () => ref
                        .read(alarmViewModelProvider)
                        .toggleTypes(AlarmOrderType.SELL, ref)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2), width: 1),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ref.watch(alarmViewModelProvider
                              .select((vm) => vm.selectedOrderType)) ==
                          AlarmOrderType.BUY
                      ? LocaleKeys.alarm_form_sellOrderInfo.tr()
                      : LocaleKeys.alarm_form_buyOrderInfo.tr(),
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
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
          color:
              isSelected ? DefaultColorPalette.accentBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : DefaultColorPalette.darkTextSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateAlarmButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          await ref.read(alarmViewModelProvider).saveAlarm(context, ref);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: DefaultColorPalette.accentBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Text(
          LocaleKeys.alarm_form_createButton.tr(),
          style: const TextStyle(
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

  // Dark theme colors
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color accentBlue = Color(0xFF2196F3);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(alarmViewModelProvider);
    final orderType = ref.watch(alarmViewModelProvider
        .select((viewModel) => viewModel.selectedOrderType));
    final alarmType = ref.watch(alarmViewModelProvider
        .select((viewModel) => viewModel.selectedAlarmType));
    final alarmCondition = ref.watch(alarmViewModelProvider
        .select((viewModel) => viewModel.selectedCondition));

    // Dinamik metin oluşturma
    String getAlarmText() {
      String currencyPair = ref.watch(alarmViewModelProvider
          .select((viewModel) => viewModel.selectedCurrency));
      String priceValue = ref.watch(alarmViewModelProvider
          .select((viewModel) => viewModel.selectedCurrencyPrice.toString()));
      String percentValue = ref.watch(alarmViewModelProvider
          .select((viewModel) => viewModel.selectedCurrencyPercent.toString()));

      String orderTypeText = orderType == AlarmOrderType.BUY
          ? LocaleKeys.alarm_dynamic_orderType_buy.tr()
          : LocaleKeys.alarm_dynamic_orderType_sell.tr();

      String conditionText;
      String templateKey;

      if (alarmType == AlarmType.PRICE) {
        conditionText = alarmCondition == AlarmCondition.DOWN
            ? LocaleKeys.alarm_dynamic_conditionDownPrice.tr()
            : LocaleKeys.alarm_dynamic_conditionUpPrice.tr();
        templateKey = LocaleKeys.alarm_dynamic_price;
        return templateKey.tr(namedArgs: {
          'currency': currencyPair,
          'orderType': orderTypeText,
          'price': priceValue,
          'condition': conditionText,
        });
      } else {
        // PERCENT
        conditionText = alarmCondition == AlarmCondition.DOWN
            ? LocaleKeys.alarm_dynamic_conditionDownPercent.tr()
            : LocaleKeys.alarm_dynamic_conditionUpPercent.tr();
        templateKey = LocaleKeys.alarm_dynamic_percent;
        return templateKey.tr(namedArgs: {
          'currency': currencyPair,
          'orderType': orderTypeText,
          'percent': percentValue,
          'condition': conditionText,
        });
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DefaultColorPalette.accentBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: DefaultColorPalette.accentBlue.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: DefaultColorPalette.accentBlue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              getAlarmText(),
              style: const TextStyle(
                // color: darkText,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationPermissionCard extends StatelessWidget {
  const NotificationPermissionCard({super.key});

  Future<void> _openSettings() async {
    await openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_off, color: Colors.orange, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              LocaleKeys.alarm_alarm_snackbar_enable_notifications.tr(),
              style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: _openSettings,
            child: Text(LocaleKeys.alarm_alarm_snackbar_open_settings.tr()),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
          ),
        ],
      ),
    );
  }
}
