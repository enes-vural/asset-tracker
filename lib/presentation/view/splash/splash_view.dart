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

  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  Future<void> startAnimation(tickerThis) async {
    // Animasyon controller'larını başlat
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: tickerThis,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: tickerThis,
    );

    // Animasyonları tanımla
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Animasyonları başlat
      _fadeController.forward();
      Future.delayed(const Duration(milliseconds: 150), () {
        _scaleController.forward();
      });
    });
  }

  void disposeAnimation() {
    _fadeController.dispose();
    _scaleController.dispose();
  }

  @override
  void initState() {
    super.initState();
    startAnimation(this);
    initalize();
  }

  @override
  void dispose() {
    disposeAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultColorPalette.vanillaWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            const Center(
              child: CircleMainLogoWidget(
                key: WidgetKeys.splashLogoKey,
              ),
            ),
            SizedBox(height: 32.h),
            AnimatedBuilder(
              animation: Listenable.merge(
                  [fadeAnimation, scaleAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: scaleAnimation.value,
                  child: Opacity(
                    opacity: fadeAnimation.value,
                    child: Text(
                      'PaRota',
                      style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2.0,
                                color: const Color.fromARGB(255, 10, 46, 82),
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
