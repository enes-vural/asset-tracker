import 'package:asset_tracker/core/config/localization/localization_manager.dart';
import 'package:flutter/material.dart';

class LanguageSwitcherWidget extends StatelessWidget {
  const LanguageSwitcherWidget({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.language,
          color: Colors.green[600],
          size: 20,
        ),
      ),
      title: const Text(
        'Dil',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: const Text(
        'Uygulama dilini seçin',
        style: TextStyle(fontSize: 14),
      ),
      trailing: InkWell(
        onTap: () async {
          await LocalizationManager().changeLanguage(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            LocalizationManager().getCurrentLanguageDisplay(context),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}
