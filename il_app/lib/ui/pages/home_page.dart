import 'package:flutter/material.dart';
import 'package:il_app/ui/widgets/navigation_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const AppNavigationDrawer(),
      body: const Center(
        child: Text('Home page'),
      ),
    );
  }
}
