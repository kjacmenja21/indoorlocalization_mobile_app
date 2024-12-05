import 'package:flutter/material.dart';
import 'package:il_app/logic/vm/asset_dashboard_page_view_model.dart';
import 'package:il_app/ui/widgets/navigation_drawer.dart';
import 'package:provider/provider.dart';

class AssetDashboardPage extends StatelessWidget {
  const AssetDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: const AppNavigationDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ChangeNotifierProvider(
          create: (context) => AssetDashboardPageViewModel(),
          child: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Consumer<AssetDashboardPageViewModel>(
      builder: (context, model, child) {
        return Column(
          children: [],
        );
      },
    );
  }
}
