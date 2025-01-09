import 'package:flutter/foundation.dart';
import 'package:il_core/il_entities.dart';

class AssetsChangeNotifier extends ChangeNotifier {
  final FloorMap _floorMap;
  List<Asset> _assets = [];

  AssetsChangeNotifier(FloorMap floorMap) : _floorMap = floorMap;

  void showAssets(List<Asset> assets) {
    _assets = assets;
    notifyListeners();
  }

  FloorMap get floorMap => _floorMap;
  List<Asset> get assets => _assets;
}
