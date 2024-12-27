import 'package:il_core/il_entities.dart';

class AssetTailmapData {
  final Asset asset;
  late final FloorMap floorMap;

  final DateTime startDate;
  final DateTime endDate;

  final List<AssetPositionHistory> positionHistory;

  AssetTailmapData({
    required this.asset,
    required this.startDate,
    required this.endDate,
    required this.positionHistory,
  }) {
    floorMap = asset.floorMap!;
  }
}
