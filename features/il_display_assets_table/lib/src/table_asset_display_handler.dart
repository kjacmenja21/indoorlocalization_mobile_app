import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  Widget buildDisplayWidget({required VoidCallback onTap}) {
    return ListTile(
      title: const Text('Table'),
      leading: const FaIcon(FontAwesomeIcons.table),
      onTap: onTap,
    );
  }

  @override
  Widget buildWidget(BuildContext context) {
    return ListenableBuilder(
      listenable: changeNotifier,
      builder: (context, child) {
        if (changeNotifier.floorMap == null) {
          return Container();
        }

        return AssetsTableWidget(
          floorMap: changeNotifier.floorMap!,
          assets: changeNotifier.assets,
        );
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
