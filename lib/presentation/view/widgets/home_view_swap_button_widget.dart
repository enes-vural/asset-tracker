import 'package:flutter/material.dart';

class HomeViewSwapButtonWidget extends StatelessWidget {
  const HomeViewSwapButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3 - 20,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.purple.shade200.withOpacity(1), // Hafif transparan beyaz
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.2),
            blurRadius: 10.0,
            offset: const Offset(0, 4), // Alt tarafa doğru gölge
          ),
        ],
      ),
      child: const Center(
        child: SizedBox(
          height: 50,
          child: Center(
            child: Text(
              "SWAP",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
