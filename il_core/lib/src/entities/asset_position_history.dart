import 'package:il_core/src/models/asset_location.dart';

class AssetPositionHistory {
  int id;
  int assetId;

  double x;
  double y;
  DateTime timestamp;

  int floorMapId;

  AssetPositionHistory({
    required this.id,
    required this.assetId,
    required this.x,
    required this.y,
    required this.timestamp,
    required this.floorMapId,
  });

  factory AssetPositionHistory.fromJson(Map<String, dynamic> json) {
    return AssetPositionHistory(
      id: json['id'],
      assetId: json['assetId'],
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      floorMapId: json['floorMapId'],
    );
  }

  factory AssetPositionHistory.fromAssetLocation(AssetLocation location) {
    return AssetPositionHistory(
      id: 0,
      assetId: location.id,
      x: location.x,
      y: location.y,
      timestamp: DateTime.now(),
      floorMapId: location.floorMapId,
    );
  }
}
