import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_display_assets_table/src/logic/asset_info_change_notifier.dart';
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

    assetsChangeNotifier = AssetInfoChangeNotifier(floorMap);
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
      leadingIcon: const FaIcon(FontAwesomeIcons.tableCells),
      child: const Text('Show table'),
    );
  }

  @override
  Widget buildWidget(BuildContext context) {
    if (assetsChangeNotifier == null) {
      return const Center(child: CircularProgressIndicator());
    }

    var changeNotifier = assetsChangeNotifier as AssetInfoChangeNotifier;

    return ListenableBuilder(
      listenable: changeNotifier,
      builder: (context, child) {
        return AssetsTableWidget(
          assetData: changeNotifier.assetData,
        );
      },
    );
  }

  @override
  void dispose() {
    deactivate();
  }
}
