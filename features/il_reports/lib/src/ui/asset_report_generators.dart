import 'package:flutter/material.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_exceptions.dart';
import 'package:il_reports/src/logic/asset_heatmap_data_generator.dart';
import 'package:il_reports/src/ui/widgets/asset_heatmap_report.dart';
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

    data.startDate = startDate;
    data.endDate = endDate;

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
