import 'package:il_app/logic/vm/view_model.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';

class AssetDashboardPageViewModel extends ViewModel {
  late final List<IAssetDisplayHandler> _displayHandlers;
  late final IAssetService _assetService;
  late final IAssetLocationTracker _assetLocationTracker;
  late final IFloorMapService _floorMapService;

  late IAssetDisplayHandler _currentDisplayHandler;

  List<FloorMap> _floorMaps = [];
  FloorMap? _currentFloorMap;

  List<Asset> _assets = [];

  bool _isLoading = true;

  AssetDashboardPageViewModel({
    required List<IAssetDisplayHandler> displayHandlers,
    required IAssetService assetService,
    required IAssetLocationTracker assetLocationTracker,
    required IFloorMapService floorMapService,
    int? initFloorMapId,
  }) {
    _displayHandlers = displayHandlers;
    _assetService = assetService;
    _assetLocationTracker = assetLocationTracker;
    _floorMapService = floorMapService;

    _currentDisplayHandler = displayHandlers.first;
    _init(initFloorMapId);
  }

  void showAssets() {
    if (_currentFloorMap == null) {
      return;
    }

    _currentDisplayHandler.showAssets(floorMap: _currentFloorMap!, assets: _assets);
  }

  Future<void> changeFloorMap(FloorMap floorMap) async {
    _isLoading = true;
    _currentFloorMap = floorMap;
    await _assetLocationTracker.close();
    notifyListeners();

    if (floorMap.zones == null) {
      var zones = await _floorMapService.getFloorMapZones(floorMap.id);
      floorMap.zones = zones;
    }

    _assets = await _assetService.getAssetsByFloorMap(floorMap.id);
    await _assetLocationTracker.connect();

    _assetLocationTracker.addListener((location) {
      if (location.floorMapId != _currentFloorMap?.id) {
        return;
      }

      int i = _assets.indexWhere((e) => e.id == location.id);
      if (i == -1) {
        return;
      }

      var asset = _assets[i];

      asset.x = location.x;
      asset.y = location.y;
      showAssets();
    });

    _isLoading = false;
    notifyListeners();
    showAssets();
  }

  void changeDisplayHandler(IAssetDisplayHandler handler) {
    if (handler == _currentDisplayHandler) {
      return;
    }

    _currentDisplayHandler = handler;
    notifyListeners();
    showAssets();
  }

  List<IAssetDisplayHandler> get displayHandlers => _displayHandlers;
  IAssetDisplayHandler get currentDisplayHandler => _currentDisplayHandler;

  List<FloorMap> get floorMaps => _floorMaps;
  FloorMap? get currentFloorMap => _currentFloorMap;

  bool get isLoading => _isLoading;

  Future<void> _init(int? initFloorMapId) async {
    await _loadFloorMaps();

    if (initFloorMapId != null) {
      var i = _floorMaps.indexWhere((e) => e.id == initFloorMapId);

      if (i != -1) {
        changeFloorMap(_floorMaps[i]);
      }
    }
  }

  Future<void> _loadFloorMaps() async {
    _floorMaps = await _floorMapService.getAllFloorMaps();
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _assetLocationTracker.close();

    for (var e in _displayHandlers) {
      e.dispose();
    }

    super.dispose();
  }
}
