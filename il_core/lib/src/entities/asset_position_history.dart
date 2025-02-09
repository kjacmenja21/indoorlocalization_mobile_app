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
}
