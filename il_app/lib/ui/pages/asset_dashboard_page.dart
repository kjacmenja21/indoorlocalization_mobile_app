import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_app/logic/vm/asset_dashboard_page_view_model.dart';
import 'package:il_app/ui/widgets/navigation_drawer.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_display_assets_map/il_display_assets_map.dart';
import 'package:il_display_assets_table/il_display_assets_table.dart';
import 'package:il_ws/il_ws.dart';
import 'package:provider/provider.dart';

class AssetDashboardPage extends StatelessWidget {
  const AssetDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AssetDashboardPageViewModel(
        displayHandlers: [
          MapAssetDisplayHandler(),
          TableAssetDisplayHandler(),
        ],
        assetService: FakeAssetService(),
        floorMapService: FakeFloorMapService(),
      ),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.filter),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.display),
              ),
              const SizedBox(width: 10),
            ],
          ),
          drawer: const AppNavigationDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: buildBody(),
          ),
        );
      }),
    );
  }

  Widget buildBody() {
    return Consumer<AssetDashboardPageViewModel>(
      builder: (context, model, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownMenu<FloorMap>(
              label: const Text('Facility'),
              width: 200,
              enableSearch: false,
              requestFocusOnTap: false,
              enableFilter: false,
              onSelected: (value) {
                if (value != null) {
                  model.changeFloorMap(value);
                }
              },
              dropdownMenuEntries: model.floorMaps.map((e) {
                return DropdownMenuEntry(
                  value: e,
                  label: e.name,
                  leadingIcon: const FaIcon(FontAwesomeIcons.building),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (model.currentFloorMap != null)
              Expanded(
                child: model.currentDisplayHandler.buildWidget(context),
              ),
          ],
        );
      },
    );
  }
}
