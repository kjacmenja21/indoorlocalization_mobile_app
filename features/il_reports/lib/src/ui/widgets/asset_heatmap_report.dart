import 'package:flutter/material.dart';
import 'package:il_core/il_widgets.dart';
import 'package:il_reports/src/models/asset_heatmap_data.dart';
import 'package:il_reports/src/ui/widgets/asset_heatmap_painter.dart';
import 'package:il_reports/src/ui/widgets/asset_report_info.dart';

class AssetHeatmapReportWidget extends StatelessWidget {
  final AssetHeatmapData data;

  const AssetHeatmapReportWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AssetReportInfo(
            asset: data.asset,
            startDate: data.heatmapData.startDate,
            endDate: data.heatmapData.endDate,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _HeatmapReportWidget(data),
          ),
        ],
      ),
    );
  }
}

class _HeatmapReportWidget extends StatelessWidget {
  final AssetHeatmapData data;

  const _HeatmapReportWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return FloorMapWidget(
      floorMap: data.floorMap,
      backgroundBuilder: (imageRenderer) {
        return CustomPaint(
          willChange: false,
          isComplex: true,
          size: data.floorMap.size,
          painter: AssetHeatmapBackgroundPainter(
            data: data,
            imageRenderer: imageRenderer,
          ),
        );
      },
      foregroundBuilder: (size, transform) {
        return CustomPaint(
          willChange: true,
          size: size,
          painter: AssetHeatmapForegroundPainter(
            transform: transform,
            data: data,
          ),
        );
      },
    );
  }
}
