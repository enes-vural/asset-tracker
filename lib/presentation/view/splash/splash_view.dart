// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:asset_tracker/injection.dart';
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

  // Animation Controllers
  late AnimationController _logoTransformController;
  late AnimationController _textRevealController;
  late AnimationController _loadingController;

  // Logo Transform Animations
  late Animation<double> _logoScaleAnimation;
  late Animation<Offset> _logoPositionAnimation;
  late Animation<double> _logoOpacityAnimation;

  // PR Letters Animations
  late Animation<double> _pLetterOpacityAnimation;
  late Animation<Offset> _pLetterPositionAnimation;
  late Animation<double> _rLetterOpacityAnimation;
  late Animation<Offset> _rLetterPositionAnimation;

  // Text Reveal Animations
  late Animation<double> _aLetterOpacityAnimation;
  late Animation<Offset> _aLetterPositionAnimation;
  late Animation<double> _rotaTextOpacityAnimation;
  late Animation<Offset> _rotaTextPositionAnimation;

  @override
  void initState() {
    super.initState();
    initalize();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Logo Transform Controller (Logo küçülme ve kayma)
    _logoTransformController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Text Reveal Controller (Harflerin belirmesi)
    _textRevealController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Loading Controller
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // ============ LOGO TRANSFORM ANIMATIONS ============

    // Ana logo opacity (kaybolma)
    _logoOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoTransformController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    ));

    // Ana logo scale (küçülme)
    _logoScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _logoTransformController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
    ));

    // Ana logo position (hafif sola kayma)
    _logoPositionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.3, 0), // Daha az kayma
    ).animate(CurvedAnimation(
      parent: _logoTransformController,
      curve: const Interval(0.1, 0.5, curve: Curves.easeOutCubic),
    ));

    // ============ PR LETTERS ANIMATIONS ============

    // P harfi belirme ve SOLA kayma
    _pLetterOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoTransformController,
      curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
    ));

    _pLetterPositionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.6, 0), // P'yi sola kaydır
    ).animate(CurvedAnimation(
      parent: _logoTransformController,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic),
    ));

    // R harfi belirme ve SAĞA kayma
    _rLetterOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoTransformController,
      curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
    ));

    _rLetterPositionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.6, 0), // R'yi sağa kaydır
    ).animate(CurvedAnimation(
      parent: _logoTransformController,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic),
    ));

    // ============ TEXT REVEAL ANIMATIONS ============

    // "a" harfi belirme (P'nin hemen yanına)
    _aLetterOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textRevealController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    _aLetterPositionAnimation = Tween<Offset>(
      begin: const Offset(-0.1, 0),
      end: const Offset(0.0, 0), // P'nin hemen yanında
    ).animate(CurvedAnimation(
      parent: _textRevealController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
    ));

    // "ota" kısmı belirme (R'nin hemen yanına)
    _rotaTextOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textRevealController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    ));

    _rotaTextPositionAnimation = Tween<Offset>(
      begin: const Offset(0.2, 0),
      end: const Offset(0.0, 0), // R'nin hemen yanında
    ).animate(CurvedAnimation(
      parent: _textRevealController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
    ));
  }

  void _startAnimationSequence() async {
    try {
      // Native splash'in bitmesini bekle
      await Future.delayed(const Duration(milliseconds: 300));

      // Logo transform animasyonunu başlat (küçülme, kayma, PR harflerine dönüşüm)
      _logoTransformController.forward();

      // Logo transform bitince text reveal'ı başlat
      await Future.delayed(const Duration(milliseconds: 400));
      _textRevealController.forward();

      // Loading animasyonunu başlat
      _loadingController.repeat();
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  }

  @override
  void dispose() {
    _logoTransformController.dispose();
    _textRevealController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ana Logo ve Text Container
            SizedBox(
              height: 120.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Orjinal PaRota Logosu (Küçülüp kaybolan)
                  _buildOriginalLogo(),

                  // PR Harfleri + aRota Text Container
                  _buildTransformedLogoText(),
                ],
              ),
            ),

            const SizedBox(height: 80),

            // Loading Dots
            _buildLoadingDots(),
          ],
        ),
      ),
    );
  }

  Widget _buildOriginalLogo() {
    return AnimatedBuilder(
      animation: _logoTransformController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Transform.translate(
            offset: Offset(
              _logoPositionAnimation.value.dx * 50.w, // Daha az hareket
              _logoPositionAnimation.value.dy * 50.h,
            ),
            child: Opacity(
              opacity: _logoOpacityAnimation.value,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // P harfi (arkada)
                      Positioned(
                        left: 25.w,
                        child: Text(
                          'P',
                          style: TextStyle(
                            color: const Color(0xFF2563EB),
                            fontSize: 48,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                      ),
                      // R harfi (önde, hafif overlap)
                      Positioned(
                        left: 45.w,
                        child: Text(
                          'R',
                          style: TextStyle(
                            color: const Color(0xFF1E40AF),
                            fontSize: 48,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransformedLogoText() {
    return Container(
      width: 300, // Daha geniş alan
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // P Harfi (sola kaydırılıyor)
          AnimatedBuilder(
            animation: _logoTransformController,
            builder: (context, child) {
              return Positioned(
                left: 100 +
                    (_pLetterPositionAnimation.value.dx * 40.w), // Sola kaydır
                top: 10.h,
                child: Opacity(
                  opacity: _pLetterOpacityAnimation.value,
                  child: Text(
                    'P',
                    style: TextStyle(
                      fontSize: 64,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2563EB),
                      height: 1.0,
                    ),
                  ),
                ),
              );
            },
          ),

          // R Harfi (sağa kaydırılıyor)
          AnimatedBuilder(
            animation: _logoTransformController,
            builder: (context, child) {
              return Positioned(
                left: 100.w +
                    (_rLetterPositionAnimation.value.dx * 40.w), // Sağa kaydır
                top: 10,
                child: Opacity(
                  opacity: _rLetterOpacityAnimation.value,
                  child: Text(
                    'R',
                    style: TextStyle(
                      fontSize: 64,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E40AF),
                      height: 1.0,
                    ),
                  ),
                ),
              );
            },
          ),

          // "a" Harfi (P ve R arasına geliyor)
          AnimatedBuilder(
            animation: _textRevealController,
            builder: (context, child) {
              final pFinalPos =
                  100 + (_pLetterPositionAnimation.value.dx * 40.w);
              return Positioned(
                left: pFinalPos +
                    35.w +
                    (_aLetterPositionAnimation.value.dx *
                        10.w), // P'nin yanında
                top: 25.h,
                child: Opacity(
                  opacity: _aLetterOpacityAnimation.value,
                  child: Text(
                    'a',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ),
              );
            },
          ),

          // "ota" Kısmı (R'nin sağına geliyor)
          AnimatedBuilder(
            animation: _textRevealController,
            builder: (context, child) {
              final rFinalPos = 130 + (_rLetterPositionAnimation.value.dx * 40);
              return Positioned(
                left: rFinalPos +
                    15 +
                    (_rotaTextPositionAnimation.value.dx * 10), // R'nin yanında
                top: 25,
                child: Opacity(
                  opacity: _rotaTextOpacityAnimation.value,
                  child: Text(
                    'ota',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingDots() {
    return AnimatedBuilder(
      animation: _loadingController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animationValue = (_loadingController.value + delay) % 1.0;
            final scale = (1.0 + 0.5 * (1.0 - (animationValue - 0.5).abs() * 2))
                .clamp(0.5, 1.5);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563EB),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
