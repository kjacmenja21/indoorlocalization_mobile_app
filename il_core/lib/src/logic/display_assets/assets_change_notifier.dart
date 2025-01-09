import 'package:flutter/foundation.dart';
import 'package:il_core/il_entities.dart';

class AssetsChangeNotifier extends ChangeNotifier {
  final FloorMap _floorMap;
  List<Asset> _assets = [];

  AssetsChangeNotifier(FloorMap floorMap) : _floorMap = floorMap;

  void setAssets(List<Asset> assets) {
    _assets = assets;
    notifyListeners();
  }

  void updateAssetLocation(AssetLocation location) {
    int i = _assets.indexWhere((e) => e.id == location.id);
    if (i == -1) {
      return;
    }

    var asset = _assets[i];

    asset.x = location.x;
    asset.y = location.y;
    asset.lastSync = DateTime.now();

    notifyListeners();
  }

  FloorMap get floorMap => _floorMap;
  List<Asset> get assets => _assets;
}
