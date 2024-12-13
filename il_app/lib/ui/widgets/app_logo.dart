import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset('assets/images/sick-mobilisis-logo.png'),
        ),
        const SizedBox(height: 10),
        Text('Indoor Localization', style: Theme.of(context).textTheme.headlineLarge),
      ],
    );
  }
}
