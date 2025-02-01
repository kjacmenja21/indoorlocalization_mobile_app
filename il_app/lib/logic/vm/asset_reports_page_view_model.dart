import 'package:il_app/logic/vm/view_model.dart';
import 'package:il_app/models/message.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_exceptions.dart';
import 'package:il_ws/il_ws.dart';

class AssetReportsPageViewModel extends ViewModel {
  final predefinedPeriods = [
    ('Last 6 hours', const Duration(hours: 6)),
    ('Last 12 hours', const Duration(hours: 12)),
    ('Last 24 hours', const Duration(hours: 24)),
    ('Last week', const Duration(days: 7)),
    ('Last 2 weeks', const Duration(days: 14)),
  ];

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
  final void Function(Object e) showExceptionPage;

  AssetReportsPageViewModel({
    required IAssetService assetService,
    required IFloorMapService floorMapService,
    required List<IAssetReportGenerator> reportGenerators,
    required this.openReportViewPage,
    required this.showExceptionPage,
    int? initAssetId,
  }) {
    _assetService = assetService;
    _floorMapService = floorMapService;
    _reportGenerators = reportGenerators;

    _loadData(initAssetId);
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

      var floorMap = _selectedAsset!.floorMap!;
      floorMap.zones ??= await _floorMapService.getFloorMapZones(floorMap.id);

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

  void setPredefinedPeriod(Duration duration) {
    var now = DateTime.now();

    _startDate = now.subtract(duration);
    _endDate = now;
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

  Future<void> _loadData(int? initAssetId) async {
    try {
      await Future.wait([
        _loadAssets(),
        _loadFloorMaps(),
      ]);
    } catch (e) {
      showExceptionPage(e);
      return;
    }

    _isLoading = false;
    notifyListeners();

    if (initAssetId != null) {
      var i = _assets.indexWhere((e) => e.id == initAssetId);

      if (i != -1) {
        selectAsset(_assets[i]);
      }
    }
  }

  Future<void> _loadAssets() async {
    _assets = await _assetService.getAllAssets();
  }

  Future<void> _loadFloorMaps() async {
    _floorMaps = await _floorMapService.getAllFloorMaps();
  }
}
