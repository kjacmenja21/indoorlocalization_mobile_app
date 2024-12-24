import 'package:il_app/logic/vm/view_model.dart';
import 'package:il_app/models/message.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_exceptions.dart';
import 'package:il_ws/il_ws.dart';

class AssetReportsPageViewModel extends ViewModel {
  late final IAssetService _assetService;
  late final IFloorMapService _floorMapService;

  late final List<IAssetReportGenerator> _reportGenerators;

  List<FloorMap> _floorMaps = [];
  List<Asset> _assets = [];

  Asset? _selectedAsset;
  DateTime? _startDate;
  DateTime? _endDate;

  Message? _message;
  bool _isLoading = true;

  final void Function(IAssetReportGenerator generator, dynamic data) openReportViewPage;

  AssetReportsPageViewModel({
    required IAssetService assetService,
    required IFloorMapService floorMapService,
    required List<IAssetReportGenerator> reportGenerators,
    required this.openReportViewPage,
  }) {
    _assetService = assetService;
    _floorMapService = floorMapService;
    _reportGenerators = reportGenerators;

    _loadData();
  }

  List<Asset> get assets => _assets;
  List<FloorMap> get floorMaps => _floorMaps;

  Asset? get selectedAsset => _selectedAsset;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  List<IAssetReportGenerator> get reportGenerators => _reportGenerators;
  Message? get message => _message;
  bool get isLoading => _isLoading;

  Future<void> generateReport(IAssetReportGenerator generator) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    try {
      _checkUserInput();

      dynamic data = await generator.generateData(
        asset: _selectedAsset!,
        startDate: _startDate!,
        endDate: _endDate!,
      );

      _isLoading = false;
      notifyListeners();

      openReportViewPage(generator, data);
    } catch (a) {
      var e = AppException.from(a);
      _message = Message.error(e.message);
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectAsset(Asset asset) {
    _selectedAsset = asset;
    notifyListeners();
  }

  void setStartDate(DateTime value) {
    _startDate = value;
    notifyListeners();
  }

  void setEndDate(DateTime value) {
    _endDate = value;
    notifyListeners();
  }

  void clearMessage() {
    _message = null;
    notifyListeners();
  }

  void _checkUserInput() {
    if (_selectedAsset == null) {
      throw AppException('Please select asset.');
    }

    if (_startDate == null) {
      throw AppException('Please select start date.');
    }

    if (_startDate == null) {
      throw AppException('Please select end date.');
    }

    if (_startDate!.compareTo(_endDate!) >= 0) {
      throw AppException('Start date must be before end date.');
    }
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
