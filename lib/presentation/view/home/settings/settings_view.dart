import 'package:asset_tracker/core/config/localization/localization_manager.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/theme_manager.dart'
    hide DefaultColorPalette;
import 'package:asset_tracker/core/constants/enums/theme/app_theme_mode_enum.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/domain/entities/database/cache/app_theme_entity.dart';
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

    return Scaffold(
      backgroundColor: DefaultColorPalette.grey100,
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
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Hesap ve uygulama ayarlarını yönetin',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
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
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withOpacity(0.1)
              : Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red[600] : Colors.blue[600],
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red[600] : Colors.grey[800],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
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
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 60,
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue[600],
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Önemli Bilgilendirme',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
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
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Versiyon 1.0.0',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('İsim ve Soyisim Düzenle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'İsim',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: surnameController,
              decoration: const InputDecoration(
                labelText: 'Soyisim',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement name update logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('İsim güncellendi')),
              );
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hesabı Sil'),
        content: const Text(
          'Hesabınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              // TODO: Implement account deletion logic
              Navigator.pop(context);
            },
            child: const Text('Sil', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Dil Seçin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Türkçe'),
              value: 'Türkçe',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(SettingsViewModel viewModel, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Çıkış Yap'),
        content: const Text(
          'Hesabınızdan çıkış yapmak istediğinizden emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              viewModel.signOut(ref, context);
              Navigator.pop(context);
            },
            child:
                const Text('Çıkış Yap', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showUserAgreement() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Kullanıcı Sözleşmesi'),
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

4. SORUMLULUK REDDI
Uygulama geliştiricileri, uygulamadan kaynaklanan herhangi bir zarar için sorumluluk kabul etmez.

5. DEĞİŞİKLİKLER
Bu sözleşme herhangi bir zamanda güncellenebilir.

Son güncelleme: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}
              ''',
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.light_mode,
          color: Colors.purple[600],
          size: 20,
        ),
      ),
      title: const Text(
        'Tema',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'Açık tema aktif',
        style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),
      ),
      // trailing: Switch(
      //   value: true,
      //   onChanged: (value) {},
      //   activeColor: Colors.purple[600],
      // ),
      onTap: () async {
        await ref.read(appThemeProvider.notifier).switchAppTheme();
        debugPrint("TIKLANDI");
      },
    );
  }
}
