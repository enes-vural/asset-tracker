import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/presentation/view/widgets/custom_card_widget.dart';
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
      "Start trading with ease!",
      "Secure your assets today!",
      "Welcome to Asset Tracker",
    ];
    List<String> cardTexts = [
      "Start trading with ease!",
      "Secure your assets today!",
      "Finish setting up your wallet to begin swapping seconds",
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
            description: cardTexts[index],
          );
        },
        reverse: true,
        onPageChanged: (index) {},
      ),
    );
  }
}
