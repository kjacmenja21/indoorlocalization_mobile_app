import 'package:flutter/foundation.dart';
import 'package:il_core/il_entities.dart';

class AssetsChangeNotifier extends ChangeNotifier {
  final FloorMap floorMap;
  List<Asset> assets = [];

  AssetsChangeNotifier(this.floorMap);

  void setAssets(List<Asset> assets) {
    assets = assets;
    notifyListeners();
  }

  bool updateAssetLocation(AssetLocation location) {
    int i = assets.indexWhere((e) => e.id == location.id);
    if (i == -1) {
      return false;
    }

    assets[i].updateLocation(location);
    notifyListeners();
    return true;
  }
}
