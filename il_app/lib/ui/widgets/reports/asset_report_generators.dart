import 'package:flutter/material.dart';
import 'package:il_app/ui/widgets/reports/asset_heatmap_report.dart';
import 'package:il_core/il_core.dart';

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
