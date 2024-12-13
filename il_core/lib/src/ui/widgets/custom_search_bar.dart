import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const CustomSearchBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: () => controller.clear(),
          icon: const Icon(Icons.close),
        ),
      ),
    );
  }
}
