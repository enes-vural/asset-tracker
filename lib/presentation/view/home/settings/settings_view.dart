import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/home/widgets/language_switcher_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/theme_switcher_widget.dart';
import 'package:asset_tracker/presentation/view_model/settings/settings_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  bool isDarkMode = false;
  String selectedLanguage = 'Türkçe';
  bool _showSupportCode = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(settingsViewModelProvider);
    final theme = Theme.of(context);
    final isEmailVerified =
        ref.read(authGlobalProvider).getCurrentUser?.emailVerified ?? true;
    final currentUser = ref.read(authGlobalProvider).getCurrentUser;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const SizedBox(height: 20),
              Text(
                LocaleKeys.home_settings_settings.tr(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                LocaleKeys.home_settings_settingsDesc.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),

              // Email Verification Notice
              if (viewModel.isAuthorized && !isEmailVerified) ...[
                const SizedBox(height: 24),
                _buildEmailVerificationNotice(viewModel),
              ],

              const SizedBox(height: 40),

              // Account Section
              viewModel.isAuthorized
                  ? _buildSectionTitle(LocaleKeys.home_settings_account.tr())
                  : const CustomSizedBox.empty(),
              viewModel.isAuthorized
                  ? const SizedBox(height: 16)
                  : const CustomSizedBox.empty(),
              viewModel.isAuthorized
                  ? _buildSettingsCard([
                      _buildSettingsTile(
                        icon: Icons.person_outline,
                        title: LocaleKeys.home_settings_nameLastname.tr(),
                        subtitle:
                            LocaleKeys.home_settings_nameLastnameDesc.tr(),
                        onTap: () => _showNameEditDialog(viewModel),
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.logout,
                        title: LocaleKeys.home_settings_exit.tr(),
                        subtitle: LocaleKeys.home_settings_exitDesc.tr(),
                        onTap: () => _showLogoutDialog(viewModel, ref),
                        isDestructive: true,
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.delete_outline,
                        title: LocaleKeys.home_settings_remove.tr(),
                        subtitle: LocaleKeys.home_settings_removeDesc.tr(),
                        onTap: () => _showDeleteAccountDialog(viewModel),
                        isDestructive: true,
                      ),
                    ])
                  : const CustomSizedBox.empty(),

              const SizedBox(height: 32),

              // App Settings Section
              _buildSectionTitle(LocaleKeys.home_settings_app.tr()),
              const SizedBox(height: 16),
              _buildSettingsCard([
                _buildLanguageTile(),
                _buildDivider(),
                _buildThemeTile(),
              ]),
              const SizedBox(height: 32),

              // Legal Section
              viewModel.isAuthorized
                  ? _buildSectionTitle(LocaleKeys.home_settings_legal.tr())
                  : const CustomSizedBox.empty(),
              viewModel.isAuthorized
                  ? const SizedBox(height: 16)
                  : const CustomSizedBox.empty(),
              viewModel.isAuthorized
                  ? _buildSettingsCard([
                      _buildSettingsTile(
                        icon: Icons.description_outlined,
                        title: LocaleKeys.home_settings_privacyPolicy.tr(),
                        subtitle:
                            LocaleKeys.home_settings_privacyPolicyDesc.tr(),
                        onTap: () => _showUserAgreement(),
                      ),
                    ])
                  : const CustomSizedBox.empty(),

              const SizedBox(height: 32),

              // Info Section
              _buildInfoCard(),

              // Support Section (Only for authorized users)
              if (viewModel.isAuthorized && currentUser?.uid != null) ...[
                const SizedBox(height: 32),
                _buildSupportSection(currentUser?.uid),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportSection(String? uid) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _showSupportCode = !_showSupportCode;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.support_agent_outlined,
                    color: primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    LocaleKeys.home_settings_supportTitle.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _showSupportCode
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (_showSupportCode) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.home_settings_supportDesc.tr(),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          uid ?? "",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: uid ?? ""));
                          EasySnackBar.show(context,
                              LocaleKeys.home_settings_supportCopy.tr());
                        },
                        icon: Icon(
                          Icons.copy_outlined,
                          size: 18,
                          color: primaryColor,
                        ),
                        tooltip: 'Kopyala',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmailVerificationNotice(SettingsViewModel viewModel) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.mark_email_unread_outlined,
              color: Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.home_settings_validateEmail.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  LocaleKeys.home_settings_validateEmailText.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              viewModel.sendEmailVerification(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: Text(
              LocaleKeys.home_settings_validate.tr(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkTheme
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? errorColor.withOpacity(0.1)
              : primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? errorColor : primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDestructive ? errorColor : theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.chevron_right,
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ),
      onTap: onTap,
    );
  }

  Widget _buildLanguageTile() {
    return LanguageSwitcherWidget(context: context);
  }

  Widget _buildThemeTile() {
    return ThemeSwitcherWidget();
  }

  Widget _buildDivider() {
    final theme = Theme.of(context);
    return Divider(
      height: 1,
      thickness: 1,
      color: theme.dividerColor,
      indent: 60,
    );
  }

  Widget _buildInfoCard() {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                LocaleKeys.home_settings_importantText.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.home_settings_importantDesc.tr(),
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${LocaleKeys.home_settings_version.tr()}: 1.0.0',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showNameEditDialog(SettingsViewModel viewModel) {
    viewModel.initControllerText();
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          LocaleKeys.home_settings_editNameSurname.tr(),
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: viewModel.nameController,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: LocaleKeys.home_settings_name.tr(),
                labelStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewModel.surnameController,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: LocaleKeys.home_settings_surname.tr(),
                labelStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleKeys.home_settings_cancel.tr(),
              style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            onPressed: () async {
              await viewModel.changeUserInfo(context);
            },
            child: Text(LocaleKeys.home_settings_save.tr()),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(SettingsViewModel viewModel) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          LocaleKeys.home_settings_remove.tr(),
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Text(
          LocaleKeys.home_settings_removePopDesc.tr(),
          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Routers.instance.pop(context),
            child: Text(
              LocaleKeys.home_settings_cancel.tr(),
              style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            onPressed: () {
              viewModel.deleteAccount(context);
            },
            child: Text(
              LocaleKeys.home_settings_remove.tr(),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(SettingsViewModel viewModel, WidgetRef ref) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          LocaleKeys.home_settings_signOut.tr(),
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Text(
          LocaleKeys.home_settings_signoutPopDesc.tr(),
          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleKeys.home_settings_cancel.tr(),
              style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            onPressed: () {
              viewModel.signOut(ref, context);
              Navigator.pop(context);
            },
            child: Text(LocaleKeys.home_settings_signOut.tr()),
          ),
        ],
      ),
    );
  }

  void _showUserAgreement() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          LocaleKeys.home_settings_userAgreement.tr(),
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Text(
              '''
KULLANICI SÖZLEŞMESİ

1. GENEL HÜKÜMLER
Bu sözleşme, PaRota uygulamasının kullanım şartlarını belirler.

2. UYGULAMANIN AMACI
PaRota, yalnızca bilgilendirme amaçlı geliştirilmiş bir uygulamadır. Ticari bir geçerliliği bulunmamaktadır.

3. KULLANICI SORUMLULUKLARI
- Uygulama içerisindeki bilgileri kendi sorumluluğunuzda kullanın
- Uygulamayı yasa dışı amaçlarla kullanmayın
- Diğer kullanıcıların haklarına saygı gösterin

4. SORUMLULUK REDDİ
Uygulama geliştiricileri, uygulamadan kaynaklanan herhangi bir zarar için sorumluluk kabul etmez.

5. DEĞİŞİKLİKLER
Bu sözleşme herhangi bir zamanda güncellenebilir.

Son güncelleme: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}
              ''',
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              LocaleKeys.home_settings_close.tr(),
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
