import 'package:flutter/foundation.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';

class AssetDashboardPageViewModel extends ChangeNotifier {
  late final List<IAssetDisplayHandler> _displayHandlers;
  late final IAssetService _assetService;
  late final IFloorMapService _floorMapService;

  List<FloorMap> _floorMaps = [];
  FloorMap? _currentFloorMap;

  late IAssetDisplayHandler _currentDisplayHandler;

  List<Asset> _assets = [];

  AssetDashboardPageViewModel({
    required List<IAssetDisplayHandler> displayHandlers,
    required IAssetService assetService,
    required IFloorMapService floorMapService,
  }) {
    _displayHandlers = displayHandlers;
    _assetService = assetService;
    _floorMapService = floorMapService;

    _currentDisplayHandler = displayHandlers.first;
    _loadFloorMaps();
  }

  void showAssets() {
    _currentDisplayHandler.showAssets(_assets);
  }

  Future<void> changeFloorMap(FloorMap floorMap) async {
    _currentFloorMap = floorMap;
    _assets = await _assetService.getAssetsByFloorMap(floorMap.id);
    notifyListeners();
    showAssets();
  }

  void changeDisplayHandler(IAssetDisplayHandler handler) {
    _currentDisplayHandler = handler;
    notifyListeners();
    showAssets();
  }

  List<IAssetDisplayHandler> get displayHandlers => _displayHandlers;
  IAssetDisplayHandler get currentDisplayHandler => _currentDisplayHandler;

  List<FloorMap> get floorMaps => _floorMaps;
  FloorMap? get currentFloorMap => _currentFloorMap;

  Future<void> _loadFloorMaps() async {
    _floorMaps = await _floorMapService.getAllFloorMaps();
    notifyListeners();
  }

  @override
  void dispose() {
    for (var e in _displayHandlers) {
      e.dispose();
    }

    super.dispose();
  }
}
