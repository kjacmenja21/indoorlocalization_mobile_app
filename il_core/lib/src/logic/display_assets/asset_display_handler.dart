import 'package:flutter/widgets.dart';
import 'package:il_core/il_entities.dart';

class AssetDisplayChangeNotifier extends ChangeNotifier {
  FloorMap? floorMap;
  List<Asset> assets = [];

  bool _disposed = false;

  void show({required FloorMap floorMap, required List<Asset> assets}) {
    this.floorMap = floorMap;
    this.assets = assets;

    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
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
