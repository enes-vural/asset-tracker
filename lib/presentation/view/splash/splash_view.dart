// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:asset_tracker/core/constants/global/key/widget_keys.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/widgets/circle_logo_widget.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  Future<void> initalize() async =>
      await ref.read(splashViewModelProvider.notifier).init(ref, context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initalize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //dark blue for splash background color
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      //default body
      body: const Center(
        child: CircleMainLogoWidget(
          key: WidgetKeys.splashLogoKey,
        ),
      ),
    );
  }
}
