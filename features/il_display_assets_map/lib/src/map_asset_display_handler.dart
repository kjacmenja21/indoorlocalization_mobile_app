import 'package:flutter/material.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';

class MapAssetDisplayHandler implements IAssetDisplayHandler {
  @override
  late AssetDisplayChangeNotifier changeNotifier;

  MapAssetDisplayHandler() {
    changeNotifier = AssetDisplayChangeNotifier();
  }

  @override
  String getDisplayName() {
    return 'Map';
  }

  @override
  Widget buildWidget(BuildContext context) {
    return ListenableBuilder(
      listenable: changeNotifier,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Map'),
            const SizedBox(height: 10),
            ...changeNotifier.assets.map((e) {
              return Text(e.name);
            }),
          ],
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
