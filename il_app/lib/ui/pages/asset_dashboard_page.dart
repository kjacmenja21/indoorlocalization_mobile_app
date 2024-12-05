import 'package:flutter/material.dart';
import 'package:il_app/logic/vm/asset_dashboard_page_view_model.dart';
import 'package:il_app/ui/widgets/navigation_drawer.dart';
import 'package:il_display_assets_map/il_display_assets_map.dart';
import 'package:il_display_assets_table/il_display_assets_table.dart';
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
          create: (context) => AssetDashboardPageViewModel(
            displayHandlers: [
              MapAssetDisplayHandler(),
              TableAssetDisplayHandler(),
            ],
          ),
          child: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Consumer<AssetDashboardPageViewModel>(
      builder: (context, model, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () => model.showAssets(),
              child: const Text('Show assets'),
            ),
            const SizedBox(height: 20),
            ...model.displayHandlers.map((e) {
              return TextButton(
                onPressed: () => model.changeDisplayHandler(e),
                child: Text(e.getDisplayName()),
              );
            }),
            const SizedBox(height: 20),
            model.currentDisplayHandler.buildWidget(context),
          ],
        );
      },
    );
  }
}
