import 'package:flutter/material.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_display_assets_table/src/widgets/assets_table_widget.dart';

class TableAssetDisplayHandler implements IAssetDisplayHandler {
  @override
  late AssetDisplayChangeNotifier changeNotifier;

  TableAssetDisplayHandler() {
    changeNotifier = AssetDisplayChangeNotifier();
  }

  @override
  String getDisplayName() {
    return 'Table';
  }

  @override
  Widget buildWidget(BuildContext context) {
    return ListenableBuilder(
      listenable: changeNotifier,
      builder: (context, child) {
        return AssetsTableWidget(assets: changeNotifier.assets);
      },
    );
  }

  @override
  void showAssets({required FloorMap floorMap, required List<Asset> assets}) {
    changeNotifier.show(floorMap: floorMap, assets: assets);
  }

  @override
  void dispose() {
    changeNotifier.dispose();
  }
}
