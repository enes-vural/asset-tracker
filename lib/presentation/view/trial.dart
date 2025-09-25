import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

@RoutePage()
class TrialView extends ConsumerStatefulWidget {
  const TrialView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TrialViewState();
}

class _TrialViewState extends ConsumerState<TrialView>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _textController;
  late AnimationController _sparkleController;
  late AnimationController _floatingController;
  
  late Animation<double> _heartScale;
  late Animation<double> _textFade;
  late Animation<double> _sparkleRotation;
  late Animation<double> _floatingOffset;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    
    _sparkleController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _heartScale = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.easeInOut,
    ));

    _textFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    _sparkleRotation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.linear,
    ));

    _floatingOffset = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    // Animasyonları başlat
    _heartController.repeat(reverse: true);
    _textController.forward();
    _sparkleController.repeat();
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _heartController.dispose();
    _textController.dispose();
    _sparkleController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF0F5), // Lavender blush
              Color(0xFFFFE4E6), // Misty rose
              Color(0xFFFFF8DC), // Cornsilk
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Üst kısım - Sparkle animasyonları
              Container(
                height: 100,
                child: Stack(
                  children: [
                    ...List.generate(8, (index) {
                      return AnimatedBuilder(
                        animation: _sparkleController,
                        builder: (context, child) {
                          return Positioned(
                            left: 50.0 + index * 40,
                            top: 20 + sin(_sparkleRotation.value + index) * 10,
                            child: Transform.rotate(
                              angle: _sparkleRotation.value,
                              child: Icon(
                                Icons.star,
                                color: Colors.pink.withOpacity(0.6),
                                size: 16,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
              
              // Ana içerik
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Büyük kalp animasyonu
                      AnimatedBuilder(
                        animation: _heartScale,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _heartScale.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    Color(0xFFFF69B4),
                                    Color(0xFFFF1493),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pink.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                          );
                        },
                      ),
                      
                      SizedBox(height: 40),
                      
                      // Azize isminin özel gösterimi
                      AnimatedBuilder(
                        animation: _textFade,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _textFade.value,
                            child: Column(
                              children: [
                                // Her harf için ayrı animasyon
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: 'AZIZE'
                                      .split('')
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int index = entry.key;
                                    String letter = entry.value;
                                    return AnimatedBuilder(
                                      animation: _floatingController,
                                      builder: (context, child) {
                                        return Transform.translate(
                                          offset: Offset(
                                              0,
                                              _floatingOffset.value *
                                                  sin(index * 0.5)),
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 4),
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFFFF69B4),
                                                  Color(0xFFFF1493),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.pink
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              letter,
                                              style: TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 2,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),

                                SizedBox(height: 30),
                                
                                // Sevimli mesaj
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.pink.withOpacity(0.2),
                                        blurRadius: 15,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Naber Civciv Civciv ♡ ♡',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFFD5006D),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              // Alt kısım - Küçük kalpler
              Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return AnimatedBuilder(
                      animation: _heartController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 0.8 +
                              sin(_heartController.value * 2 * pi + index) *
                                  0.2,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.pink.withOpacity(0.7),
                            size: 24,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Tatlı bir floating action button
      floatingActionButton: AnimatedBuilder(
        animation: _heartScale,
        builder: (context, child) {
          return Transform.scale(
            scale: _heartScale.value * 0.8,
            child: FloatingActionButton(
              onPressed: () {
                // Animasyonları yeniden başlat
                _textController.reset();
                _textController.forward();
              },
              backgroundColor: Color(0xFFFF69B4),
              child: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
