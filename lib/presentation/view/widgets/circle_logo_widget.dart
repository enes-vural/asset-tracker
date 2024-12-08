import 'package:flutter/material.dart';

class CircleLogoWidget extends StatelessWidget {
  const CircleLogoWidget({
    super.key,
    required this.radius,
  });

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: radius,
      child: Image.asset("assets/image/main_logo.png"),
    );
  }
}
