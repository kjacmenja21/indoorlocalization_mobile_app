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
  List<Asset> _visibleAssets = [];

  bool _isLoading = true;

  AssetDashboardPageViewModel({
    required List<IAssetDisplayHandler> displayHandlers,
    required IAssetService assetService,
    required IAssetLocationTracker assetLocationTracker,
    required IFloorMapService floorMapService,
    int? initFloorMapId,
    int? initAssetId,
  }) {
    _displayHandlers = displayHandlers;
    _assetService = assetService;
    _assetLocationTracker = assetLocationTracker;
    _floorMapService = floorMapService;

    _currentDisplayHandler = displayHandlers.first;
    _init(initFloorMapId, initAssetId);
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
    _visibleAssets = _assets;

    await _assetLocationTracker.connect();

    _assetLocationTracker.addListener((location) {
      if (location.floorMapId != _currentFloorMap?.id) {
        return;
      }

      bool updated = _currentDisplayHandler.changeNotifier.updateAssetLocation(location);

      if (!updated) {
        int i = _assets.indexWhere((e) => e.id == location.id);

        if (i != -1) {
          _assets[i].updateLocation(location);
        }
      }
    });

    _currentDisplayHandler.deactivate();
    _currentDisplayHandler.activate(floorMap);

    _isLoading = false;
    notifyListeners();
    _currentDisplayHandler.changeNotifier.setAssets(visibleAssets);
  }

  void changeDisplayHandler(IAssetDisplayHandler handler) {
    if (handler == _currentDisplayHandler) {
      return;
    }

    _currentDisplayHandler.deactivate();
    _currentDisplayHandler = handler;
    _currentDisplayHandler.activate(_currentFloorMap!);

    notifyListeners();
    _currentDisplayHandler.changeNotifier.setAssets(visibleAssets);
  }

  void updateAssetVisibility(List<(int id, bool visible)> visibility) {
    for (var (id, visible) in visibility) {
      int i = _assets.indexWhere((e) => e.id == id);

      if (i != -1) {
        _assets[i].visible = visible;
      }
    }

    _visibleAssets = assets.where((e) => e.visible).toList();
    _currentDisplayHandler.changeNotifier.setAssets(visibleAssets);
  }

  List<IAssetDisplayHandler> get displayHandlers => _displayHandlers;
  IAssetDisplayHandler get currentDisplayHandler => _currentDisplayHandler;

  List<FloorMap> get floorMaps => _floorMaps;
  FloorMap? get currentFloorMap => _currentFloorMap;

  List<Asset> get assets => _assets;
  List<Asset> get visibleAssets => _visibleAssets;

  bool get isLoading => _isLoading;

  Future<void> _init(int? initFloorMapId, int? initAssetId) async {
    await _loadFloorMaps();

    if (initFloorMapId != null) {
      var i = _floorMaps.indexWhere((e) => e.id == initFloorMapId);

      if (i != -1) {
        await changeFloorMap(_floorMaps[i]);
      }
    }

    if (initAssetId != null) {
      for (var asset in assets) {
        asset.visible = asset.id == initAssetId;
      }

      _visibleAssets = assets.where((e) => e.visible).toList();
      _currentDisplayHandler.changeNotifier.setAssets(visibleAssets);
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
