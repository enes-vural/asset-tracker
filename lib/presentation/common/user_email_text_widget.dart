import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserEmailTextWidget extends ConsumerWidget {
  const UserEmailTextWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      ref.read(authGlobalProvider.notifier).getCurrentUser?.email.toString() ??
          DefaultLocalStrings.emptyText,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
