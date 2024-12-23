import 'package:il_app/logic/vm/view_model.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';

class AssetReportsPageViewModel extends ViewModel {
  late final IAssetService _assetService;
  late final IFloorMapService _floorMapService;

  List<FloorMap> _floorMaps = [];
  List<Asset> _assets = [];

  Asset? _selectedAsset;

  bool _isLoading = true;

  AssetReportsPageViewModel({
    required IAssetService assetService,
    required IFloorMapService floorMapService,
  }) {
    _assetService = assetService;
    _floorMapService = floorMapService;

    _loadData();
  }

  List<Asset> get assets => _assets;
  List<FloorMap> get floorMaps => _floorMaps;
  Asset? get selectedAsset => _selectedAsset;

  bool get isLoading => _isLoading;

  void selectAsset(Asset asset) {
    _selectedAsset = asset;
    notifyListeners();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadAssets(),
      _loadFloorMaps(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadAssets() async {
    _assets = await _assetService.getAllAssets();
  }

  Future<void> _loadFloorMaps() async {
    _floorMaps = await _floorMapService.getAllFloorMaps();
  }
}
