class AssetLocation {
  final int id;

  final double x;
  final double y;

  final int floorMapId;

  AssetLocation({
    required this.id,
    required this.x,
    required this.y,
    required this.floorMapId,
  });

  @override
  String toString() {
    var x = this.x.toStringAsFixed(1);
    var y = this.y.toStringAsFixed(1);
    return 'AssetLocation(assetId: $id, floorMapId: $floorMapId, x: $x, y: $y)';
  }
}
