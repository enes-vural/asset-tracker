import 'package:asset_tracker/core/config/theme/app_size.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserEmailTextWidget extends ConsumerWidget {
  const UserEmailTextWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      ref.read(authGlobalProvider.notifier).getCurrentUser?.email ?? "Misafir",
      style: TextStyle(
        color: Colors.black,
        fontSize: AppSize.mediumText,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
