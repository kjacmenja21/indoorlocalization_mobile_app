import 'package:flutter/foundation.dart';
import 'package:il_core/il_entities.dart';

class AssetsChangeNotifier extends ChangeNotifier {
  final FloorMap floorMap;
  List<Asset> assets = [];

  AssetsChangeNotifier(this.floorMap);

  void setAssets(List<Asset> assets) {
    this.assets = assets;
    notifyListeners();
  }

  void updatedAssetLocation(int index, Asset asset) {
    notifyListeners();
  }
}
