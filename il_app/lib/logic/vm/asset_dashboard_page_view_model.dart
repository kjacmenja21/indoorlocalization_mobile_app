import 'dart:async';
import 'dart:developer';

import 'package:il_app/logic/vm/view_model.dart';
import 'package:il_app/models/message.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_exceptions.dart';
import 'package:il_ws/il_ws.dart';

class AssetDashboardPageViewModel extends ViewModel {
  late final List<IAssetDisplayHandler> _displayHandlers;

  late final IAssetService _assetService;
  late final IFloorMapService _floorMapService;

  late final IAssetLocationTracker _assetLocationTracker;
  StreamSubscription<AssetLocation>? _assetLocationStreamSub;

  late IAssetDisplayHandler _currentDisplayHandler;

  List<FloorMap> _floorMaps = [];
  FloorMap? _currentFloorMap;

  List<Asset> _assets = [];
  List<Asset> _visibleAssets = [];

  bool _isLoading = true;
  Message? _message;

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
    init(initFloorMapId, initAssetId);
  }

  Future<void> changeFloorMap(FloorMap floorMap) async {
    if (floorMap == _currentFloorMap) {
      return;
    }

    _isLoading = true;
    _currentFloorMap = floorMap;
    notifyListeners();

    if (floorMap.zones == null) {
      var zones = await _floorMapService.getFloorMapZones(floorMap.id);
      floorMap.zones = zones;
    }

    _assets = await _assetService.getAssetsByFloorMap(floorMap.id);
    _visibleAssets = _assets;

    _currentDisplayHandler.deactivate();
    _currentDisplayHandler.activate(floorMap);

    _isLoading = false;
    notifyListeners();

    _currentDisplayHandler.changeNotifier.setAssets(visibleAssets);
  }

  void changeDisplayHandler(IAssetDisplayHandler handler) {
    if (handler == _currentDisplayHandler || _currentFloorMap == null) {
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
  Message? get message => _message;

  Future<void> init(int? initFloorMapId, int? initAssetId) async {
    _message = null;
    _isLoading = true;
    notifyListeners();

    try {
      _floorMaps = await _floorMapService.getAllFloorMaps();
      await _startAssetLocationTracker();
    } catch (a) {
      var e = AppException.from(a);

      _assetLocationTracker.close();
      _assetLocationStreamSub?.cancel();

      _message = Message.error(e.message);
      log(e.message);

      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = false;
    notifyListeners();

    await _autoSelect(initFloorMapId, initAssetId);
  }

  Future<void> _startAssetLocationTracker() async {
    await _assetLocationTracker.connect();
    _assetLocationStreamSub = _assetLocationTracker.stream.listen(_onAssetLocationUpdate);
  }

  void _onAssetLocationUpdate(AssetLocation location) {
    if (location.floorMapId != _currentFloorMap?.id) {
      return;
    }

    int i = visibleAssets.indexWhere((e) => e.id == location.id);

    if (i != -1) {
      visibleAssets[i].updateLocation(location);
      _currentDisplayHandler.changeNotifier.updatedAssetLocation(i, visibleAssets[i]);
      return;
    }

    i = assets.indexWhere((e) => e.id == location.id);

    if (i != -1) {
      assets[i].updateLocation(location);
    }
  }

  Future<void> _autoSelect(int? initFloorMapId, int? initAssetId) async {
    if (initFloorMapId != null) {
      var i = _floorMaps.indexWhere((e) => e.id == initFloorMapId);

      if (i != -1) {
        await changeFloorMap(_floorMaps[i]);
      }
    }

    if (initAssetId != null) {
      var i = _assets.indexWhere((e) => e.id == initAssetId);

      if (i != -1) {
        for (var asset in _assets) {
          asset.visible = asset.id == initAssetId;
        }

        _visibleAssets = assets.where((e) => e.visible).toList();
        _currentDisplayHandler.changeNotifier.setAssets(visibleAssets);
      }
    }
  }

  @override
  void dispose() {
    _assetLocationTracker.close();
    _assetLocationStreamSub?.cancel();

    for (var e in _displayHandlers) {
      e.dispose();
    }

    super.dispose();
  }
}
