import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_display_assets_table/src/widgets/assets_table_widget.dart';

class TableAssetDisplayHandler implements IAssetDisplayHandler {
  @override
  AssetsChangeNotifier? assetsChangeNotifier;

  TableAssetDisplayHandler();

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
      title: const Text('Table'),
      leading: const FaIcon(FontAwesomeIcons.table),
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
        return AssetsTableWidget(
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
