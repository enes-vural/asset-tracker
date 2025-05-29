// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/constants/global/key/widget_keys.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/widgets/circle_logo_widget.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView>
    with TickerProviderStateMixin {
  Future<void> initalize() async =>
      await ref.read(splashViewModelProvider.notifier).init(ref, context);

  Future<void> startAnimation() async =>
      ref.read(splashViewModelProvider.notifier).startAnimation(this);

  @override
  void initState() {
    super.initState();
    startAnimation();
    initalize();
  }

  @override
  void dispose() {
    ref.read(splashViewModelProvider.notifier).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(splashViewModelProvider);
    return Scaffold(
      backgroundColor: DefaultColorPalette.vanillaWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            const CircleMainLogoWidget(
              key: WidgetKeys.splashLogoKey,
            ),
            SizedBox(height: 32.h),
            AnimatedBuilder(
              animation: Listenable.merge(
                  [viewModel.fadeAnimation, viewModel.scaleAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: viewModel.scaleAnimation.value,
                  child: Opacity(
                    opacity: viewModel.fadeAnimation.value,
                    child: Text(
                      'Paratik',
                      style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2.0,
                                color: const Color.fromARGB(255, 10, 73, 164),
                              ) ??
                          TextStyle(
                            fontFamily: "Manrope",
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            color: Colors.blue,
                          ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
