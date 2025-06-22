import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_form_widget.dart';
import 'package:asset_tracker/presentation/view_model/auth/auth_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-posta adresi gerekli';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Geçerli bir e-posta adresi girin';
    }
    return null;
  }

  Future<void> _onResetPassword(WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    ref.read(authViewModelProvider).sendResetEmailLink();

    try {
      //viewModel need here:
      //Offline action can be added here. (suggest)

      if (mounted) {
        _showSuccessDialog(ref);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Bir hata oluştu. Lütfen tekrar deneyin.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog(WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'E-posta Gönderildi',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Şifre sıfırlama bağlantısı ${ref.read(authViewModelProvider).emailController.text} adresine gönderildi. E-posta kutunuzu kontrol edin.',
          style: const TextStyle(
            fontFamily: 'Manrope',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Routers.instance.pop(context);
            },
            child: const Text(
              'Tamam',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Manrope'),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final viewModel = ref.read(authViewModelProvider);

    return Scaffold(
      backgroundColor:
          isDarkMode ? theme.scaffoldBackgroundColor : Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          onPressed: () => Routers.instance.pop(context),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: screenHeight - 100,
          child: CustomPadding.mediumHorizontal(
            widget: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Icon
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.lock_reset,
                                size: 50,
                                color: theme.primaryColor,
                              ),
                            ),
                            const CustomSizedBox.largeGap(),

                            // Title
                            Text(
                              'Şifremi Unuttum',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                                fontFamily: 'Manrope',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const CustomSizedBox.smallGap(),

                            // Subtitle
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'E-posta adresinizi girin, size şifre sıfırlama bağlantısı gönderelim.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDarkMode
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade600,
                                  fontFamily: 'Manrope',
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const CustomSizedBox.hugeGap(),

                      // Form Section
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthFormWidget.email(
                              emailController: viewModel.emailController,
                              emailValidator: _emailValidator,
                              hasTitle: true,
                              hasLabel: true,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _onResetPassword(ref),
                            ),
                            const CustomSizedBox.hugeGap(),
                            // Reset Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () =>
                                    _isLoading ? null : _onResetPassword(ref),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: DefaultColorPalette.mainBlue,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  disabledBackgroundColor:
                                      theme.primaryColor.withOpacity(0.6),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        'Sıfırlama Bağlantısı Gönder',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Manrope',
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Section
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Şifrenizi hatırladınız mı? ',
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.grey.shade300
                              : Colors.grey.shade600,
                          fontFamily: 'Manrope',
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Routers.instance.pop(context),
                        child: Text(
                          'Giriş Yap',
                          style: TextStyle(
                            color: DefaultColorPalette.mainBlue,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Manrope',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
