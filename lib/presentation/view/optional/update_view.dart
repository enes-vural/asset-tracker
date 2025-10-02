import 'dart:io';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/asset_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/constants/asset_constant.dart';
import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:upgrader/upgrader.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:package_info_plus/package_info_plus.dart';

@RoutePage()
class UpdateView extends StatefulWidget {
  const UpdateView({super.key});

  @override
  State<UpdateView> createState() => _UpdateViewState();
}

class _UpdateViewState extends State<UpdateView> {
  String? releaseNotes;
  String? currentVersion;
  String? latestVersion;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUpdateInfo();
  }

  String versionURL(bool isAndroid) {
    if (isAndroid) {
      return "https://raw.githubusercontent.com/enes-vural/asset-tracker/main/updates/android_appcast.xml";
    } else {
      return "https://raw.githubusercontent.com/enes-vural/asset-tracker/main/updates/ios_appcast.xml";
    }
  }

  Future<void> _loadUpdateInfo() async {
    try {
      String versionUrl = versionURL(Platform.isAndroid);

      // HTTP request ile XML'i al
      final response = await http.get(Uri.parse(versionUrl));

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final items = document.findAllElements('item');

        if (items.isNotEmpty) {
          final item = items.first;

          // Release notes (description) al
          final description = item.findElements('description').first.text;
          final version = item
              .findElements('enclosure')
              .first
              .getAttribute('sparkle:version');

          // Package info ile mevcut versiyonu al
          final packageInfo = await PackageInfo.fromPlatform();

          setState(() {
            releaseNotes = description;
            latestVersion = version;
            currentVersion = packageInfo.version;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Failed to load update info: $e');
      setState(() {
        releaseNotes = LocaleKeys.update_release_notes_fake.tr();
        latestVersion = '1.1.0';
        currentVersion = '1.0.8';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? DefaultColorPalette.darkBackground : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(height: 10.h),

                // Logo ve başlık alanı
                SizedBox(
                  width: ResponsiveSize(context).screenWidth * 0.4,
                  child: Image.asset(AssetConstant.mainLogo.toPng()),
                ),

                SizedBox(height: 10.h),

                // Ana içerik kartı
                _buildUpdateCard(context, isDark),

                SizedBox(height: 10.h),

                // Update butonu
                _buildUpdateButton(context),

                const SizedBox(height: 16),

                // Alt bilgi
                _buildFooterText(isDark),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? DefaultColorPalette.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: isDark
            ? Border.all(
                color: DefaultColorPalette.darkBorder.withOpacity(0.3),
                width: 1,
              )
            : null,
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Update icon ve başlık
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.system_update_alt,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.update_title.tr(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : DefaultColorPalette.mainBlue,
                      ),
                    ),
                    Text(
                      LocaleKeys.update_desc.tr(),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.white.withOpacity(0.7)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Release notes
          if (isLoading)
            _buildLoadingContent(isDark)
          else
            _buildReleaseNotes(isDark),

          const SizedBox(height: 20),

          // Version info
          _buildVersionInfo(isDark),
        ],
      ),
    );
  }

  Widget _buildLoadingContent(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.update_loading_text.tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? DefaultColorPalette.mainBlue : const Color(0xFF10B981),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReleaseNotes(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.update_inside_text.tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark
                ? DefaultColorPalette.vanillaWhite
                : const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF10B981).withOpacity(0.05)
                : const Color(0xFF10B981).withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF10B981).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF10B981),
                  size: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  releaseNotes ?? LocaleKeys.update_release_notes_fake.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? Colors.white.withOpacity(0.8)
                        : const Color(0xFF475569),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVersionInfo(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? DefaultColorPalette.mainBlue.withOpacity(0.08)
            : DefaultColorPalette.mainBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DefaultColorPalette.mainBlue.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.update_current_version.tr(),
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? Colors.white.withOpacity(0.7)
                      : const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'v${currentVersion ?? '1.0.8'}',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.update_new_version.tr(),
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? Colors.white.withOpacity(0.7)
                      : const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'v${latestVersion ?? '1.1.0'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _launchStore(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: DefaultColorPalette.mainBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: DefaultColorPalette.mainBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Platform.isIOS ? Icons.phone_iphone : Icons.shop,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              Platform.isIOS
                  ? LocaleKeys.update_update_app_store.tr()
                  : LocaleKeys.update_update_play_store.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchStore(BuildContext context) async {
    late final Uri storeUri;
    late final Uri webUri;
    late final String storeName;

    if (Platform.isIOS) {
      // iOS - App Store
      const String appId = '6747687974';
      storeUri = Uri.parse('itms-apps://apps.apple.com/app/id$appId');
      webUri = Uri.parse(
        'https://apps.apple.com/tr/app/parota-alt%C4%B1n-d%C3%B6viz/id$appId?platform=iphone',
      );
      storeName = 'App Store';
      debugPrint(webUri.toString());
    } else {
      // Android - Play Store
      const String packageName = 'com.sakasstudio.parota';
      storeUri = Uri.parse('market://details?id=$packageName');
      webUri = Uri.parse(
        'https://play.google.com/store/apps/details?id=$packageName',
      );
      storeName = 'Play Store';
    }

    try {
      // Haptic feedback
      HapticFeedback.lightImpact();

      // Önce store app'ini açmaya çalış
      if (await canLaunchUrl(storeUri)) {
        await launchUrl(storeUri, mode: LaunchMode.externalApplication);
      } else {
        // Store app açılamazsa web browser'da aç
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('$storeName launch error: $e');

      // Hata durumunda snackbar göster
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(LocaleKeys.update_error_launch_store.tr()),
              ],
            ),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Widget _buildFooterText(bool isDark) {
    return Column(
      children: [
        Text(
          LocaleKeys.update_force_update.tr(),
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.orange.shade400 : Colors.orange.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          LocaleKeys.update_force_desc.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? Colors.white.withOpacity(0.5)
                : const Color(0xFF94A3B8),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
