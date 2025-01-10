import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_reports/src/logic/asset_heatmap_data_generator.dart';
import 'package:il_reports/src/models/asset_heatmap_data.dart';
import 'package:il_reports/src/models/heatmap_data.dart';
import 'package:il_reports/src/ui/widgets/asset_heatmap_report.dart';
import 'package:il_ws/il_ws.dart';

class AssetHeatmapReportGenerator implements IAssetReportGenerator {
  final IAssetPositionHistoryService positionHistoryService;

  AssetHeatmapReportGenerator({
    required this.positionHistoryService,
  });

  @override
  String getReportName() {
    return 'Heatmap report';
  }

  @override
  Widget buildGenerateReportButton({required VoidCallback onTap}) {
    return OutlinedButton.icon(
      onPressed: () => onTap(),
      icon: const FaIcon(FontAwesomeIcons.solidMap),
      label: const Text('Generate heatmap report'),
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

    var generator = AssetHeatmapDataGenerator(
      floorMapSize: asset.floorMap!.size,
      cellSize: const Size.square(50),
      gradient: HeatmapData.defaultGradient,
    );

    generator.positionHistory = positionHistory;
    var heatmapData = generator.generate();

    return AssetHeatmapData(
      asset: asset,
      floorMap: asset.floorMap!,
      heatmapData: heatmapData,
    );
  }
}
