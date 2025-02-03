import 'package:flutter/material.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_display_assets_map/src/logic/live_heatmap_change_notifier.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_display_assets_map/src/widgets/live_heatmap_widget.dart';

class LiveHeatmapAssetDisplayHandler implements IAssetDisplayHandler {
  @override
  AssetsChangeNotifier? assetsChangeNotifier;

  @override
  void activate(FloorMap floorMap) {
    if (assetsChangeNotifier != null) {
      deactivate();
    }

    assetsChangeNotifier = LiveHeatmapChangeNotifier(floorMap);
  }

  @override
  void deactivate() {
    assetsChangeNotifier?.dispose();
    assetsChangeNotifier = null;
  }

  @override
  AssetsChangeNotifier get changeNotifier => assetsChangeNotifier!;

  @override
  Widget buildSelectWidget({required VoidCallback onTap}) {
    return MenuItemButton(
      onPressed: () => onTap(),
      leadingIcon: const FaIcon(FontAwesomeIcons.solidMap),
      child: const Text('Show live heatmap'),
    );
  }

  @override
  Widget buildWidget(BuildContext context) {
    if (assetsChangeNotifier == null) {
      return const Center(child: CircularProgressIndicator());
    }

    var changeNotifier = assetsChangeNotifier! as LiveHeatmapChangeNotifier;

    return LiveHeatmapWidget(model: changeNotifier);
  }

  @override
  void dispose() {
    deactivate();
  }
}
