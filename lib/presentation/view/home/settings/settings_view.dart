import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/home/widgets/language_switcher_widget.dart';
import 'package:asset_tracker/presentation/view_model/settings/settings_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(settingsViewModelProvider);
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

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
                'Ayarlar',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Hesap ve uygulama ayarlarını yönetin',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 40),

              // Account Section
              viewModel.isAuthorized
                  ? _buildSectionTitle('Hesap')
                  : CustomSizedBox.empty(),
              viewModel.isAuthorized
                  ? SizedBox(height: 16)
                  : CustomSizedBox.empty(),
              viewModel.isAuthorized
                  ? _buildSettingsCard([
                      _buildSettingsTile(
                        icon: Icons.person_outline,
                        title: 'İsim ve Soyisim',
                        subtitle: 'Kişisel bilgilerinizi düzenleyin',
                        onTap: () => _showNameEditDialog(),
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.logout,
                        title: 'Çıkış Yap',
                        subtitle: 'Hesabınızdan güvenli çıkış yapın',
                        onTap: () => _showLogoutDialog(viewModel, ref),
                        isDestructive: true,
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        icon: Icons.delete_outline,
                        title: 'Hesabı Sil',
                        subtitle: 'Hesabınızı kalıcı olarak silin',
                        onTap: () => _showDeleteAccountDialog(),
                        isDestructive: true,
                      ),
                    ])
                  : const CustomSizedBox.empty(),

              const SizedBox(height: 32),

              // App Settings Section
              _buildSectionTitle('Uygulama'),
              const SizedBox(height: 16),
              _buildSettingsCard([
                _buildLanguageTile(),
                _buildDivider(),
                _buildThemeTile(),
              ]),

              Text("THEME",
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              Text(
                ref.watch(appThemeProvider).when(
                      data: (theme) => theme.currentTheme.toString(),
                      loading: () => 'Loading...',
                      error: (error, stack) => 'Error: $error',
                    ),
              ),
              const SizedBox(height: 32),

              // Legal Section
              viewModel.isAuthorized
                  ? _buildSectionTitle('Yasal')
                  : const CustomSizedBox.empty(),
              viewModel.isAuthorized
                  ? const SizedBox(height: 16)
                  : const CustomSizedBox.empty(),
              viewModel.isAuthorized
                  ? _buildSettingsCard([
                      _buildSettingsTile(
                        icon: Icons.description_outlined,
                        title: 'Kullanıcı Sözleşmesi',
                        subtitle: 'Kullanım şartlarını görüntüleyin',
                        onTap: () => _showUserAgreement(),
                      ),
                    ])
                  : const CustomSizedBox.empty(),

              const SizedBox(height: 32),

              // Info Section
              _buildInfoCard(),

              const SizedBox(height: 40),
            ],
          ),
        ),
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
    return ThemeSwitcher();
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
                'Önemli Bilgilendirme',
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
            'PaRota sadece bilgilendirme amaçlı bir uygulamadır ve herhangi bir ticari geçerliliği bulunmamaktadır. Uygulama içerisindeki bilgiler yalnızca genel amaçlı kullanım içindir.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Versiyon 1.0.0',
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

  void _showNameEditDialog() {
    final nameController = TextEditingController();
    final surnameController = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'İsim ve Soyisim Düzenle',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: 'İsim',
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
              controller: surnameController,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: 'Soyisim',
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
              'İptal',
              style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            onPressed: () {
              // TODO: Implement name update logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'İsim güncellendi',
                    style: TextStyle(color: theme.colorScheme.onInverseSurface),
                  ),
                  backgroundColor: theme.snackBarTheme.backgroundColor,
                ),
              );
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Hesabı Sil',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Text(
          'Hesabınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'İptal',
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
              // TODO: Implement account deletion logic
              Navigator.pop(context);
            },
            child: const Text('Sil'),
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
          'Çıkış Yap',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Text(
          'Hesabınızdan çıkış yapmak istediğinizden emin misiniz?',
          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'İptal',
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
            child: const Text('Çıkış Yap'),
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
          'Kullanıcı Sözleşmesi',
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
              'Kapat',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class ThemeSwitcher extends ConsumerStatefulWidget {
  const ThemeSwitcher({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends ConsumerState<ThemeSwitcher> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(appThemeProvider);
    final contextTheme = Theme.of(context);
    final themeMode = theme.maybeWhen(
      data: (data) => data.currentTheme,
      orElse: () => ThemeMode.system,
    );

    final isDark = themeMode == ThemeMode.dark;
    final isLight = themeMode == ThemeMode.light;

    String subtitle;
    IconData icon;
    Color iconColor;

    if (isDark) {
      subtitle = "Karanlık tema aktif";
      icon = Icons.dark_mode;
      iconColor = Colors.blueGrey;
    } else if (isLight) {
      subtitle = "Açık tema aktif";
      icon = Icons.light_mode;
      iconColor = Colors.amber[800]!;
    } else {
      subtitle = "Sistem temasına göre ayarlı";
      icon = Icons.brightness_auto;
      iconColor = Colors.green[700]!;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
      title: Text(
        'Tema',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: contextTheme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: iconColor,
        ),
      ),
      onTap: () async {
        await ref.read(appThemeProvider.notifier).switchAppTheme();
      },
    );
  }
}
