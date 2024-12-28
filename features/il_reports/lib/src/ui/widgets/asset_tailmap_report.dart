import 'package:flutter/material.dart';
import 'package:il_core/il_helpers.dart';
import 'package:il_core/il_widgets.dart';
import 'package:il_reports/src/models/asset_tailmap_data.dart';
import 'package:il_reports/src/ui/widgets/asset_report_info.dart';
import 'package:il_reports/src/ui/widgets/asset_tailmap_painter.dart';

class AssetTailmapReportWidget extends StatefulWidget {
  final AssetTailmapData data;

  const AssetTailmapReportWidget({
    super.key,
    required this.data,
  });

  @override
  State<AssetTailmapReportWidget> createState() => _AssetTailmapReportWidgetState();
}

class _AssetTailmapReportWidgetState extends State<AssetTailmapReportWidget> {
  late AssetTailmapData data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  void updateCurrentPosition(int positionIndex) {
    setState(() {
      data.currentPositionIndex = positionIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentDate = DateFormats.dateTime.format(data.currentDate);
    var x = data.currentPosition.dx.round();
    var y = data.currentPosition.dy.round();

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
        const SizedBox(height: 10),
        Text('Date: $currentDate', style: Theme.of(context).textTheme.bodyLarge),
        Text('Position: $x $y', style: Theme.of(context).textTheme.bodyLarge),
        Slider(
          value: data.currentPositionIndex.toDouble(),
          min: 0,
          max: (data.positionHistory.length - 1).toDouble(),
          onChanged: (value) => updateCurrentPosition(value.round()),
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
