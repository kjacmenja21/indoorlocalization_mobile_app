import 'dart:ui';

import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_reports/il_heatmap.dart';

class LiveHeatmapChangeNotifier extends AssetsChangeNotifier {
  late AssetHeatmapDataGenerator heatmapGenerator;
  HeatmapData? heatmapData;

  LiveHeatmapChangeNotifier(super.floorMap) {
    heatmapGenerator = AssetHeatmapDataGenerator(
      cellSize: const Size.square(50),
      floorMapSize: floorMap.size,
      gradient: HeatmapData.defaultGradient,
    );
  }

  @override
  bool updateAssetLocation(AssetLocation location) {
    int i = assets.indexWhere((e) => e.id == location.id);
    if (i == -1) {
      return false;
    }

    assets[i].updateLocation(location);

    var pHistory = AssetPositionHistory.fromAssetLocation(location);
    heatmapGenerator.positionHistory.add(pHistory);

    if (heatmapGenerator.positionHistory.length >= 2) {
      heatmapData = heatmapGenerator.generate();
    }

    notifyListeners();
    return true;
  }
}
