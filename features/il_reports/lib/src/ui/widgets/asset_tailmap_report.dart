import 'package:flutter/material.dart';
import 'package:il_core/il_widgets.dart';
import 'package:il_reports/src/models/asset_tailmap_data.dart';
import 'package:il_reports/src/ui/widgets/asset_report_info.dart';
import 'package:il_reports/src/ui/widgets/asset_tailmap_painter.dart';

class AssetTailmapReportWidget extends StatelessWidget {
  final AssetTailmapData data;

  const AssetTailmapReportWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssetReportInfo(
          asset: data.asset,
          startDate: data.startDate,
          endDate: data.endDate,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: _TailmapReportWidget(data),
        ),
      ],
    );
  }
}

class _TailmapReportWidget extends StatelessWidget {
  final AssetTailmapData data;

  const _TailmapReportWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return FloorMapWidget(
      floorMap: data.floorMap,
      backgroundBuilder: (svg) {
        return CustomPaint(
          willChange: false,
          isComplex: true,
          size: data.floorMap.size,
          painter: AssetTailmapBackgroundPainter(
            data: data,
            svg: svg,
          ),
        );
      },
      foregroundBuilder: (size, transform) {
        return CustomPaint(
          willChange: true,
          size: size,
          painter: AssetTailmapForegroundPainter(
            transform: transform,
            data: data,
          ),
        );
      },
    );
  }
}
