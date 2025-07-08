// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AppReviewWidget extends StatefulWidget {
//   final VoidCallback? onDismiss;

//   const AppReviewWidget({
//     Key? key,
//     this.onDismiss,
//   }) : super(key: key);

//   @override
//   State<AppReviewWidget> createState() => _AppReviewWidgetState();
// }

// class _AppReviewWidgetState extends State<AppReviewWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _slideAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );

//     _slideAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Future<void> _openAppStore() async {
//     try {
//       String url;

//       // Platform kontrolü için dart:io import'u kullanmayalım, Theme yerine daha güvenilir yöntem
//       if (Theme.of(context).platform == TargetPlatform.android) {
//         // Android için önce market:// protokolünü dene
//         url = 'market://details?id=com.yourcompany.yourapp';

//         try {
//           await launchUrl(
//             Uri.parse(url),
//             mode: LaunchMode.externalApplication,
//           );
//         } catch (e) {
//           // Market protokolü çalışmazsa web URL'ini kullan
//           url =
//               'https://play.google.com/store/apps/details?id=com.yourcompany.yourapp';
//           await launchUrl(
//             Uri.parse(url),
//             mode: LaunchMode.externalApplication,
//           );
//         }
//       } else {
//         // iOS için App Store URL'i
//         url = 'https://apps.apple.com/app/idYOUR_APP_ID';
//         await launchUrl(
//           Uri.parse(url),
//           mode: LaunchMode.externalApplication,
//         );
//       }

//       // Kullanıcı mağazaya gittikten sonra widget'ı kaldır
//       await _markAsReviewed();
//       _dismissWidget();
//     } catch (e) {
//       print('Mağaza açılırken hata: $e');

//       // Hata durumunda kullanıcıya bilgi ver
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//                 'Mağaza açılırken bir hata oluştu. Lütfen daha sonra tekrar deneyin.'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }

//       // Hata olsa bile widget'ı kaldır
//       _dismissWidget();
//     }
//   }

//   Future<void> _markAsReviewed() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('app_reviewed', true);
//   }

//   Future<void> _dismissWidget() async {
//     await _animationController.reverse();
//     if (widget.onDismiss != null) {
//       widget.onDismiss!();
//     }
//   }

//   Future<void> _remindLater() async {
//     final prefs = await SharedPreferences.getInstance();
//     final nextReminder = DateTime.now().add(const Duration(days: 7));
//     await prefs.setString(
//         'next_review_reminder', nextReminder.toIso8601String());
//     _dismissWidget();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(0, _slideAnimation.value * 100),
//           child: Opacity(
//             opacity: _fadeAnimation.value,
//             child: Container(
//               margin: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // İkon
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.amber.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.star,
//                         color: Colors.amber,
//                         size: 32,
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Başlık
//                     const Text(
//                       'Uygulamamızı Beğendiniz mi?',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),

//                     const SizedBox(height: 8),

//                     // Açıklama
//                     Text(
//                       'Deneyiminizi diğer kullanıcılarla paylaşın! Görüşleriniz bizim için çok değerli.',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                         height: 1.4,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),

//                     const SizedBox(height: 20),

//                     // Butonlar
//                     Row(
//                       children: [
//                         // Daha sonra butonu
//                         Expanded(
//                           child: TextButton(
//                             onPressed: _remindLater,
//                             style: TextButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: Text(
//                               'Daha Sonra',
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(width: 12),

//                         // Değerlendir butonu
//                         Expanded(
//                           flex: 2,
//                           child: ElevatedButton(
//                             onPressed: _openAppStore,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue,
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               elevation: 0,
//                             ),
//                             child: const Text(
//                               'Değerlendir',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // Kullanım için yardımcı sınıf
// class ReviewManager {
//   static const String _keyAppReviewed = 'app_reviewed';
//   static const String _keyNextReminder = 'next_review_reminder';
//   static const String _keyAppOpenCount = 'app_open_count';
//   static const String _keyFirstOpenDate = 'first_open_date';

//   // Kullanıcının değerlendirme widget'ını görmesi gerekip gerekmediğini kontrol et
//   static Future<bool> shouldShowReview() async {
//     return true;
//   }

//   // Widget'ı göstermek için kullan
//   static Future<void> showReviewDialog(BuildContext context) async {
//     if (await shouldShowReview()) {
//       showDialog(
//         context: context,
//         barrierDismissible: true,
//         builder: (context) => Dialog(
//           backgroundColor: Colors.transparent,
//           child: AppReviewWidget(
//             onDismiss: () => Navigator.of(context).pop(),
//           ),
//         ),
//       );
//     }
//   }

//   // Bottom sheet olarak göstermek için
//   static Future<void> showReviewBottomSheet(BuildContext context) async {
//     if (await shouldShowReview()) {
//       showModalBottomSheet(
//         context: context,
//         backgroundColor: Colors.transparent,
//         isScrollControlled: true,
//         builder: (context) => AppReviewWidget(
//           onDismiss: () => Navigator.of(context).pop(),
//         ),
//       );
//     }
//   }

//   // TEST İÇİN: Koşulsuz göster
//   static void showReviewForced(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => AppReviewWidget(
//         onDismiss: () => Navigator.of(context).pop(),
//       ),
//     );
//   }

//   // Debug bilgileri göster
//   static Future<void> debugReviewStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final reviewed = prefs.getBool(_keyAppReviewed) ?? false;
//     final openCount = prefs.getInt(_keyAppOpenCount) ?? 0;
//     final nextReminder = prefs.getString(_keyNextReminder);
//     final firstOpen = prefs.getString(_keyFirstOpenDate);

//     print('=== REVIEW DEBUG ===');
//     print('Reviewed: $reviewed');
//     print('Open Count: $openCount');
//     print('Next Reminder: $nextReminder');
//     print('First Open: $firstOpen');
//     print('Should Show: ${await shouldShowReview()}');
//     print('==================');
//   }

//   // Test için tüm verileri sıfırla
//   static Future<void> resetReviewData() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_keyAppReviewed);
//     await prefs.remove(_keyNextReminder);
//     await prefs.remove(_keyAppOpenCount);
//     await prefs.remove(_keyFirstOpenDate);
//     print('Review data reset!');
//   }
// }
