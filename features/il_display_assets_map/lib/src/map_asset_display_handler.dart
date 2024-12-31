import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_display_assets_map/src/widgets/assets_widget.dart';

class MapAssetDisplayHandler implements IAssetDisplayHandler {
  @override
  AssetsChangeNotifier? assetsChangeNotifier;

  MapAssetDisplayHandler();

  @override
  void activate(FloorMap floorMap) {
    if (assetsChangeNotifier != null) {
      deactivate();
    }

    assetsChangeNotifier = AssetsChangeNotifier(floorMap);
  }

  @override
  void deactivate() {
    assetsChangeNotifier?.dispose();
    assetsChangeNotifier = null;
  }

  @override
  void showAssets(List<Asset> assets) {
    if (assetsChangeNotifier != null) {
      assetsChangeNotifier!.showAssets(assets);
    }
  }

  @override
  Widget buildSelectWidget({required VoidCallback onTap}) {
    return ListTile(
      title: const Text('Map'),
      leading: const FaIcon(FontAwesomeIcons.solidMap),
      onTap: onTap,
    );
  }

  @override
  Widget buildWidget(BuildContext context) {
    if (assetsChangeNotifier == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListenableBuilder(
      listenable: assetsChangeNotifier!,
      builder: (context, child) {
        return AssetsWidget(
          floorMap: assetsChangeNotifier!.floorMap,
          assets: assetsChangeNotifier!.assets,
        );
      },
    );
  }

  @override
  void dispose() {
    deactivate();
  }
}
