import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/generated/locale_keys.g.dart';
import 'package:asset_tracker/presentation/view/widgets/custom_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WelcomeCardWidget extends StatefulWidget {
  const WelcomeCardWidget({super.key});

  @override
  State<WelcomeCardWidget> createState() => _WelcomeCardWidgetState();
}

class _WelcomeCardWidgetState extends State<WelcomeCardWidget> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    List<String> cardTitles = [
      LocaleKeys.home_startTradingText.tr(),
      LocaleKeys.home_secureAssetText.tr(),
      LocaleKeys.home_welcomeAssetText.tr(),
    ];
    List<String> cardDescriptions = [
      LocaleKeys.home_startTradingText.tr(),
      LocaleKeys.home_secureAssetText.tr(),
      LocaleKeys.home_finishAssetText.tr()
    ];

    return SizedBox(
      height: 90,
      width: ResponsiveSize(context).screenWidth,
      child: PageView.builder(
        controller: _pageController,
        itemCount: cardTitles.length,
        itemBuilder: (context, index) {
          return CustomCardWidget(
            title: cardTitles[index],
            description: cardDescriptions[index],
          );
        },
        reverse: true,
        onPageChanged: (index) {},
      ),
    );
  }
}
