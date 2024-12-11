import 'package:flutter/material.dart';
import 'package:il_app/logic/vm/view_model.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';

class AssetsPageViewModel extends ViewModel {
  final tcSearch = TextEditingController();

  late final IAssetService _assetService;
  late final IFloorMapService _floorMapService;

  List<Asset> _allAssets = [];
  List<Asset> _currentAssets = [];

  List<FloorMap> _floorMaps = [];
  FloorMap? _floorMapFilter;

  bool _isLoading = true;

  AssetsPageViewModel({
    required IAssetService assetService,
    required IFloorMapService floorMapService,
  }) {
    _assetService = assetService;
    _floorMapService = floorMapService;

    tcSearch.addListener(() {
      _filterAssets();
    });

    _loadData();
  }

  void setFloorMapFilter(FloorMap? floorMap) {
    _floorMapFilter = floorMap;
    _filterAssets();
  }

  List<Asset> get assets => _currentAssets;
  List<FloorMap> get floorMaps => _floorMaps;
  bool get isLoading => _isLoading;

  void _filterAssets() {
    List<Asset> assets = _allAssets;

    if (_floorMapFilter != null) {
      var floorMapId = _floorMapFilter!.id;
      assets = assets.where((e) => e.floorMapId == floorMapId).toList();
    }

    var search = tcSearch.text.trim().toLowerCase();
    assets = _getSearchResult(search, assets);

    _currentAssets = assets;
    notifyListeners();
  }

  List<Asset> _getSearchResult(String search, List<Asset> assets) {
    if (search.isEmpty) {
      return assets;
    }

    return assets.where((asset) {
      String name = asset.name.toLowerCase();

      if (name.contains(search)) {
        return true;
      }

      return false;
    }).toList();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadAllAssets(),
      _loadFloorMaps(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadAllAssets() async {
    _allAssets = await _assetService.getAllAssets();
    _currentAssets = _allAssets;
  }

  Future<void> _loadFloorMaps() async {
    _floorMaps = await _floorMapService.getAllFloorMaps();
  }

  @override
  void dispose() {
    tcSearch.dispose();
    super.dispose();
  }
}
