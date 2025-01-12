import 'dart:ui';

import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_reports/il_heatmap.dart';
import 'package:il_display_assets_map/src/models/asset_history_data.dart';

class LiveHeatmapChangeNotifier extends AssetsChangeNotifier {
  late AssetHeatmapDataGenerator _heatmapGenerator;
  HeatmapData? _heatmapData;

  List<AssetHistoryData> _assetsHistoryData = [];

  LiveHeatmapChangeNotifier(super.floorMap) {
    _heatmapGenerator = AssetHeatmapDataGenerator(
      cellSize: const Size.square(50),
      floorMapSize: floorMap.size,
      gradient: HeatmapData.defaultGradient,
    );
  }

  @override
  void setAssets(List<Asset> assets) {
    super.setAssets(assets);

    List<AssetHistoryData> assetsHistoryData = [];

    for (var asset in assets) {
      int i = _assetsHistoryData.indexWhere((e) => e.asset.id == asset.id);

      if (i != -1) {
        assetsHistoryData.add(_assetsHistoryData[i]);
      } else {
        assetsHistoryData.add(AssetHistoryData(asset));
      }
    }

    _assetsHistoryData = assetsHistoryData;
  }

  @override
  void updatedAssetLocation(int index, Asset asset) {
    var pHistory = _getPositionHistory(asset);
    _assetsHistoryData[index].positionHistory.add(pHistory);
    _updateHeatmap();

    super.updatedAssetLocation(index, asset);
  }

  HeatmapData? get heatmapData => _heatmapData;

  void resetHeatmap() {
    _heatmapData = null;
    for (var e in _assetsHistoryData) {
      e.positionHistory.clear();
    }

    notifyListeners();
  }

  void _updateHeatmap() {
    for (var historyData in _assetsHistoryData) {
      _updateHeatmapData(historyData);
    }

    _heatmapGenerator.calculateCellPercentage(_heatmapData!);
    notifyListeners();
  }

  void _updateHeatmapData(AssetHistoryData historyData) {
    var positionHistory = historyData.positionHistory;

    if (positionHistory.length < 2) {
      return;
    }

    _heatmapGenerator.positionHistory = historyData.positionHistory;

    if (_heatmapData == null) {
      _heatmapData = _heatmapGenerator.generate();
    } else {
      _heatmapGenerator.updateHeatmapData(_heatmapData!);
    }
  }

  AssetPositionHistory _getPositionHistory(Asset asset) {
    return AssetPositionHistory(
      id: 0,
      assetId: asset.id,
      x: asset.x,
      y: asset.y,
      timestamp: DateTime.now(),
      floorMapId: floorMap.id,
    );
  }
}
