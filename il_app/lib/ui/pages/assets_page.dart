import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:il_app/logic/vm/assets_page_view_model.dart';
import 'package:il_app/ui/widgets/navigation_drawer.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_widgets.dart';
import 'package:il_ws/il_ws.dart';
import 'package:provider/provider.dart';

class AssetsPage extends StatelessWidget {
  const AssetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AssetsPageViewModel(
        assetService: AssetService(),
        floorMapService: FloorMapService(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Assets'),
        ),
        drawer: const AppNavigationDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Consumer<AssetsPageViewModel>(
      builder: (context, model, child) {
        if (model.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var assets = model.assets;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearchBar(
              controller: model.tcSearch,
            ),
            const SizedBox(height: 20),
            createFacilityMenu(model),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  var asset = assets[index];
                  return ListTile(
                    title: Text(asset.name),
                    subtitle: Text(asset.floorMap?.name ?? ''),
                    leading: const FaIcon(FontAwesomeIcons.box),
                    trailing: createAssetMenu(context, asset),
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }

  Widget createFacilityMenu(AssetsPageViewModel model) {
    return DropdownMenu<FloorMap?>(
      label: const Text('Facility'),
      enabled: !model.isLoading,
      width: 200,
      enableSearch: false,
      requestFocusOnTap: false,
      enableFilter: false,
      onSelected: (value) {
        model.setFloorMapFilter(value);
      },
      dropdownMenuEntries: [
        const DropdownMenuEntry(
          value: null,
          label: 'All facilities',
          leadingIcon: FaIcon(FontAwesomeIcons.building),
        ),
        ...model.floorMaps.map((e) {
          return DropdownMenuEntry(
            value: e,
            label: e.name,
            leadingIcon: const FaIcon(FontAwesomeIcons.building),
          );
        }),
      ],
    );
  }

  Widget createAssetMenu(BuildContext context, Asset asset) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            var extra = {
              'floorMapId': asset.floorMapId,
              'assetId': asset.id,
            };
            context.go('/asset_dashboard', extra: extra);
          },
          leadingIcon: const FaIcon(FontAwesomeIcons.solidMap),
          child: const Text('Show dashboard'),
        ),
        MenuItemButton(
          onPressed: () {
            var extra = {'assetId': asset.id};
            context.go('/asset_reports', extra: extra);
          },
          leadingIcon: const FaIcon(FontAwesomeIcons.solidChartBar),
          child: const Text('Show reports'),
        ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const FaIcon(FontAwesomeIcons.ellipsis),
        );
      },
    );
  }
}
