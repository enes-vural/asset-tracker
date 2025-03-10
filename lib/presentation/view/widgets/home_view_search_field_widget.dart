import 'package:asset_tracker/presentation/view_model/home/home_view_model.dart';
import 'package:flutter/material.dart';

class HomeViewSearchFieldWidget extends StatelessWidget {
  const HomeViewSearchFieldWidget({
    super.key,
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width /
          2, // Ekranın yarısı kadar genişlik
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white.withOpacity(0.9), // Hafif transparan beyaz
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10.0,
            offset: const Offset(0, 4), // Alt tarafa doğru gölge
          ),
        ],
      ),
      child: TextField(
        controller: viewModel.searchBarController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
        ),
      ),
    );
  }
}
