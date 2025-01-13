import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_app/logic/vm/asset_dashboard_page_view_model.dart';
import 'package:il_app/ui/widgets/asset_filter_dialog.dart';
import 'package:il_app/ui/widgets/message_card.dart';
import 'package:il_app/ui/widgets/navigation_drawer.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_display_assets_map/il_display_assets_map.dart';
import 'package:il_display_assets_table/il_display_assets_table.dart';
import 'package:il_ws/il_fake_services.dart';
import 'package:il_ws/il_ws.dart';
import 'package:provider/provider.dart';

class AssetDashboardPage extends StatelessWidget {
  late final int? initFloorMapId;
  late final int? initAssetId;

  AssetDashboardPage({super.key, Object? extra}) {
    if (extra is Map) {
      initFloorMapId = extra['floorMapId'];
      initAssetId = extra['assetId'];
    } else {
      initFloorMapId = null;
      initAssetId = null;
    }
  }

  Future<void> openAssetFilterDialog(BuildContext context) async {
    var model = context.read<AssetDashboardPageViewModel>();

    List<(int id, bool visible)>? result = await showDialog(
      context: context,
      builder: (context) => AssetFilterDialog(
        assets: model.assets,
      ),
    );

    if (result != null) {
      model.updateAssetVisibility(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AssetDashboardPageViewModel(
        displayHandlers: [
          MapAssetDisplayHandler(),
          TableAssetDisplayHandler(),
          LiveHeatmapAssetDisplayHandler(),
        ],
        assetService: AssetService(),
        assetLocationTracker: AssetLocationTracker(),
        floorMapService: FakeFloorMapService(),
        initFloorMapId: initFloorMapId,
        initAssetId: initAssetId,
      ),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
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
        Widget child;

        if (model.isLoading) {
          child = const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (model.message != null) {
          child = Column(
            children: [
              MessageCard(message: model.message!),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => model.init(initFloorMapId, initAssetId),
                child: const Text("Try again"),
              ),
            ],
          );
        } else if (model.currentFloorMap == null) {
          child = Expanded(
            child: Center(
              child: Text('Select a facility', style: Theme.of(context).textTheme.titleLarge),
            ),
          );
        } else {
          child = Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: model.currentDisplayHandler.buildWidget(context),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            createHeader(context, model),
            child,
          ],
        );
      },
    );
  }

  Widget createHeader(BuildContext context, AssetDashboardPageViewModel model) {
    bool enableButtons = model.isLoading == false && model.currentFloorMap != null;

    return Row(
      children: [
        Expanded(child: createFacilityMenu(model)),
        const SizedBox(width: 10),
        IconButton(
          onPressed: enableButtons ? () => openAssetFilterDialog(context) : null,
          icon: const Icon(Icons.filter_list),
        ),
        createAssetDisplayModeMenu(context, enableButtons, model.displayHandlers),
      ],
    );
  }

  Widget createFacilityMenu(AssetDashboardPageViewModel model) {
    return DropdownMenu<FloorMap>(
      initialSelection: model.currentFloorMap,
      label: const Text('Facility'),
      enabled: !model.isLoading && model.message == null,
      enableSearch: false,
      requestFocusOnTap: false,
      enableFilter: false,
      expandedInsets: const EdgeInsets.all(0),
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
    );
  }

  Widget createAssetDisplayModeMenu(BuildContext context, bool enable, List<IAssetDisplayHandler> handlers) {
    return MenuAnchor(
      menuChildren: handlers.map((handler) {
        return handler.buildSelectWidget(
          onTap: () {
            var model = context.read<AssetDashboardPageViewModel>();
            model.changeDisplayHandler(handler);
          },
        );
      }).toList(),
      builder: (context, controller, child) {
        return IconButton(
          onPressed: enable
              ? () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                }
              : null,
          icon: const Icon(Icons.monitor),
        );
      },
    );
  }
}
