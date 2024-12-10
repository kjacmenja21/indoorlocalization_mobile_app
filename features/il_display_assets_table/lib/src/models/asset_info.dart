import 'package:il_core/il_entities.dart';

class AssetInfo {
  int id;
  String name;
  double x;
  double y;
  String zone;

  AssetInfo({
    required this.id,
    required this.name,
    required this.x,
    required this.y,
    required this.zone,
  });

  factory AssetInfo.fromAsset(Asset asset, FloorMap floorMap) {
    return AssetInfo(
      id: asset.id,
      name: asset.name,
      x: asset.x,
      y: asset.y,
      zone: '',
    );
  }
}
