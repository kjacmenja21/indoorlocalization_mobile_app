import 'package:flutter/foundation.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';

class AssetDashboardPageViewModel extends ChangeNotifier {
  late final List<IAssetDisplayHandler> _displayHandlers;
  late IAssetDisplayHandler _currentDisplayHandler;

  List<Asset> assets = [];

  AssetDashboardPageViewModel({
    required List<IAssetDisplayHandler> displayHandlers,
  }) {
    _displayHandlers = displayHandlers;
    _currentDisplayHandler = displayHandlers.first;

    assets = [
      Asset(id: 1, name: 'Asset 1', x: 0, y: 0, lastSync: DateTime.now(), active: true, floorMapId: 1),
      Asset(id: 2, name: 'Asset 2', x: 0, y: 0, lastSync: DateTime.now(), active: true, floorMapId: 1),
      Asset(id: 3, name: 'Asset 3', x: 0, y: 0, lastSync: DateTime.now(), active: true, floorMapId: 1),
    ];
  }

  List<IAssetDisplayHandler> get displayHandlers => _displayHandlers;
  IAssetDisplayHandler get currentDisplayHandler => _currentDisplayHandler;

  void showAssets() {
    _currentDisplayHandler.showAssets(assets);
  }

  void changeDisplayHandler(IAssetDisplayHandler handler) {
    _currentDisplayHandler = handler;
    notifyListeners();
    showAssets();
  }

  @override
  void dispose() {
    for (var e in _displayHandlers) {
      e.dispose();
    }

    super.dispose();
  }
}
