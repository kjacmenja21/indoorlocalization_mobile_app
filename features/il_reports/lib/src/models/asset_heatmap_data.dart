import 'package:il_core/il_entities.dart';
import 'package:il_reports/src/models/heatmap_data.dart';

class AssetHeatmapData extends HeatmapData {
  final Asset asset;
  final FloorMap floorMap;

  AssetHeatmapData({
    required this.asset,
    required this.floorMap,
    required super.startDate,
    required super.endDate,
    required super.gradient,
  });
}
