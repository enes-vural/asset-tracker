import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthSubmitWidget extends StatelessWidget {
  const AuthSubmitWidget({
    super.key,
    required this.size,
    required this.label,
    required this.voidCallBack,
  });

  final Size size;
  final String label;
  final VoidCallback? voidCallBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => voidCallBack,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: size.height / 12.5,
          width: size.width / 2.0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: const Color.fromARGB(255, 230, 178, 58), width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                  color: const Color.fromARGB(255, 230, 178, 58),
                  fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}
