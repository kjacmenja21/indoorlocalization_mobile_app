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

  bool updateAssetLocation(AssetLocation location) {
    int i = _assets.indexWhere((e) => e.id == location.id);
    if (i == -1) {
      return false;
    }

    _assets[i].updateLocation(location);
    notifyListeners();
    return true;
  }

  FloorMap get floorMap => _floorMap;
  List<Asset> get assets => _assets;
}
