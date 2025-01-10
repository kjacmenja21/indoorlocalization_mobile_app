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
  void updatedAssetLocation(int index, Asset asset) {
    var pHistory = _getPositionHistory(asset);
    heatmapGenerator.positionHistory.add(pHistory);

    if (heatmapGenerator.positionHistory.length >= 2) {
      heatmapData = heatmapGenerator.generate();
    }

    super.updatedAssetLocation(index, asset);
  }

  AssetPositionHistory _getPositionHistory(Asset asset) {
    return AssetPositionHistory(
      id: 0,
      assetId: asset.id,
      x: asset.x,
      y: asset.y,
      timestamp: DateTime.now(),
      floorMapId: floorMap.id,
    );
  }
}
