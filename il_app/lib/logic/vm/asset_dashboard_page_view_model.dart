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
    int? initAssetId,
  }) {
    _displayHandlers = displayHandlers;
    _assetService = assetService;
    _assetLocationTracker = assetLocationTracker;
    _floorMapService = floorMapService;

    _currentDisplayHandler = displayHandlers.first;
    _init(initFloorMapId, initAssetId);
  }

  void showAssets() {
    var assets = _assets.where((e) => e.visible).toList();
    _currentDisplayHandler.changeNotifier.setAssets(assets);
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

      _currentDisplayHandler.changeNotifier.updateAssetLocation(location);
    });

    _currentDisplayHandler.deactivate();
    _currentDisplayHandler.activate(floorMap);
    _currentDisplayHandler.changeNotifier.setAssets(assets);

    _isLoading = false;
    notifyListeners();
    showAssets();
  }

  void changeDisplayHandler(IAssetDisplayHandler handler) {
    if (handler == _currentDisplayHandler) {
      return;
    }

    _currentDisplayHandler.deactivate();
    _currentDisplayHandler = handler;
    _currentDisplayHandler.activate(_currentFloorMap!);

    notifyListeners();
    showAssets();
  }

  void updateAssetVisibility(List<bool> visibility) {
    if (_assets.length != visibility.length) {
      throw ArgumentError('Visibility list length must be same as assets list length.');
    }

    for (var i = 0; i < _assets.length; i++) {
      _assets[i].visible = visibility[i];
    }

    notifyListeners();
    showAssets();
  }

  List<IAssetDisplayHandler> get displayHandlers => _displayHandlers;
  IAssetDisplayHandler get currentDisplayHandler => _currentDisplayHandler;

  List<FloorMap> get floorMaps => _floorMaps;
  FloorMap? get currentFloorMap => _currentFloorMap;

  List<Asset> get assets => _assets;

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
      var i = _assets.indexWhere((e) => e.id == initAssetId);

      if (i != -1) {
        var visibility = List.filled(_assets.length, false);
        visibility[i] = true;

        updateAssetVisibility(visibility);
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
