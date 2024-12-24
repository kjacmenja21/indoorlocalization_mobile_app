import 'package:flutter/material.dart';
import 'package:il_core/il_core.dart';
import 'package:il_reports/src/ui/widgets/asset_heatmap_report.dart';

class AssetHeatmapReportGenerator implements IAssetReportGenerator {
  @override
  Widget buildDisplayWidget({required VoidCallback onTap}) {
    return OutlinedButton(
      onPressed: () => onTap(),
      child: const Text('Generate heatmap'),
    );
  }

  @override
  Widget buildWidget(BuildContext context, data) {
    return const HeatmapReportWidget();
  }

  @override
  Future generateData({required int assetId, required int floorMapId, required DateTime startDate, required DateTime endDate}) async {
    return 0;
  }
}
