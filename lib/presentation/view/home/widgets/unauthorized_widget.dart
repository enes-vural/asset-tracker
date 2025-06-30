import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum UnAuthorizedPage {
  WALLET,
  TRADE,
}

class UnAuthorizedWidget extends StatelessWidget {
  const UnAuthorizedWidget({super.key, required this.page});

  final UnAuthorizedPage page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Satış İkonu
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: DefaultColorPalette.mainBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        page == UnAuthorizedPage.WALLET
                            ? Icons.account_balance_wallet_outlined
                            : Icons.sell_outlined,
                        size: 40,
                        color: DefaultColorPalette.mainBlue,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Başlık
                    Text(
                      LocaleKeys.auth_signIn.tr(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Manrope',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Açıklama
                    Text(
                      '\t${LocaleKeys.unAuthPage_unAuthText.tr(args: [
                            page == UnAuthorizedPage.WALLET
                                ? LocaleKeys.dashboard_wallet.tr()
                                : LocaleKeys.unAuthPage_trade.tr()
                          ])}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 48),

                    // Giriş Yap Butonu
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Routers.instance.pushNamed(
                              context, DefaultLocalStrings.loginRoute);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DefaultColorPalette.mainBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          LocaleKeys.unAuthPage_signIn.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Kayıt Ol Butonu
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {
                          Routers.instance.pushNamed(
                              context, DefaultLocalStrings.registerRoute);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: DefaultColorPalette.mainBlue,
                          side: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          LocaleKeys.unAuthPage_createAccount.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Manrope',
                            color: Colors.grey[700],
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
      ),
    );
  }
}
