import 'package:flutter/widgets.dart';
import 'package:il_core/il_entities.dart';

class AssetDisplayChangeNotifier extends ChangeNotifier {
  FloorMap? floorMap;
  List<Asset> assets = [];

  void show({required FloorMap floorMap, required List<Asset> assets}) {
    this.floorMap = floorMap;
    this.assets = assets;
    notifyListeners();
  }
}

abstract class IAssetDisplayHandler {
  @protected
  late AssetDisplayChangeNotifier changeNotifier;

  Widget buildDisplayWidget({required VoidCallback onTap});

  Widget buildWidget(BuildContext context);

  void showAssets({required FloorMap floorMap, required List<Asset> assets});

  void dispose();
}
