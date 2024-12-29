import 'package:flutter/material.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_exceptions.dart';
import 'package:il_reports/src/logic/asset_heatmap_data_generator.dart';
import 'package:il_reports/src/logic/asset_zone_retention_data_generator.dart';
import 'package:il_reports/src/models/asset_tailmap_data.dart';
import 'package:il_reports/src/ui/widgets/asset_heatmap_report.dart';
import 'package:il_reports/src/ui/widgets/asset_tailmap_report.dart';
import 'package:il_ws/il_ws.dart';

class AssetHeatmapReportGenerator implements IAssetReportGenerator {
  final IAssetPositionHistoryService positionHistoryService;

  AssetHeatmapReportGenerator({
    required this.positionHistoryService,
  });

  @override
  Widget buildDisplayWidget({required VoidCallback onTap}) {
    return OutlinedButton(
      onPressed: () => onTap(),
      child: const Text('Generate heatmap'),
    );
  }

  @override
  Widget buildWidget(BuildContext context, data) {
    return AssetHeatmapReportWidget(data: data);
  }

  @override
  Future generateData({required Asset asset, required DateTime startDate, required DateTime endDate}) async {
    var positionHistory = await positionHistoryService.getPositionHistory(
      assetId: asset.id,
      floorMapId: asset.floorMap!.id,
      startDate: startDate,
      endDate: endDate,
    );

    if (positionHistory.isEmpty) {
      throw AppException('Cannot generate heatmap report because there is no available data.');
    }

    var generator = AssetHeatmapDataGenerator();
    var data = generator.generateHeatmapData(
      asset: asset,
      positionHistory: positionHistory,
      cellSize: const Size.square(50),
    );

    data.startDate = positionHistory.first.timestamp;
    data.endDate = positionHistory.last.timestamp;

    data.gradient = const LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        Color.fromARGB(0, 255, 196, 0),
        Color.fromARGB(255, 255, 196, 0),
        Color.fromARGB(255, 255, 0, 0),
        Color.fromARGB(255, 255, 0, 0),
      ],
      stops: [
        0.0,
        0.4,
        0.9,
        1.0,
      ],
    );

    return data;
  }
}

class AssetTailmapReportGenerator implements IAssetReportGenerator {
  final IAssetPositionHistoryService positionHistoryService;

  AssetTailmapReportGenerator({
    required this.positionHistoryService,
  });

  @override
  Widget buildDisplayWidget({required VoidCallback onTap}) {
    return OutlinedButton(
      onPressed: () => onTap(),
      child: const Text('Generate tailmap'),
    );
  }

  @override
  Widget buildWidget(BuildContext context, data) {
    return AssetTailmapReportWidget(data: data);
  }

  @override
  Future generateData({
    required Asset asset,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    var positionHistory = await positionHistoryService.getPositionHistory(
      assetId: asset.id,
      floorMapId: asset.floorMap!.id,
      startDate: startDate,
      endDate: endDate,
    );

    if (positionHistory.isEmpty) {
      throw AppException('Cannot generate heatmap report because there is no available data.');
    }

    positionHistory.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return AssetTailmapData(
      asset: asset,
      startDate: positionHistory.first.timestamp,
      endDate: positionHistory.last.timestamp,
      positionHistory: positionHistory,
    );
  }
}

class AssetZoneRetentionTimeReportGenerator implements IAssetReportGenerator {
  final IAssetPositionHistoryService positionHistoryService;
  final IFloorMapService floorMapService;

  AssetZoneRetentionTimeReportGenerator({
    required this.positionHistoryService,
    required this.floorMapService,
  });

  @override
  Widget buildDisplayWidget({required VoidCallback onTap}) {
    return OutlinedButton(
      onPressed: () => onTap(),
      child: const Text('Generate zone retention time report'),
    );
  }

  @override
  Widget buildWidget(BuildContext context, data) {
    return Placeholder();
  }

  @override
  Future generateData({required Asset asset, required DateTime startDate, required DateTime endDate}) async {
    var getZoneHistory = positionHistoryService.getZoneHistory(
      assetId: asset.id,
      floorMapId: asset.floorMap!.id,
      startDate: startDate,
      endDate: endDate,
    );

    var getZones = floorMapService.getFloorMapZones(asset.floorMapId);

    var results = await Future.wait([
      getZoneHistory,
      getZones,
    ]);

    var dataGenerator = AssetZoneRetentionDataGenerator(asset: asset);
    dataGenerator.zoneHistoryData = results[0] as List<AssetZoneHistory>;
    dataGenerator.zones = results[1] as List<FloorMapZone>;

    return dataGenerator.generate();
  }
}
