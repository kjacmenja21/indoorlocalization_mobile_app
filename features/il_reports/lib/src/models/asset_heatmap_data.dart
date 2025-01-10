import 'package:il_core/il_entities.dart';
import 'package:il_reports/src/models/heatmap_data.dart';

class AssetHeatmapData {
  final Asset asset;
  final FloorMap floorMap;

  final HeatmapData heatmapData;

  AssetHeatmapData({
    required this.asset,
    required this.floorMap,
    required this.heatmapData,
  });
}
