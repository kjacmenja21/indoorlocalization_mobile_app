import 'package:flutter/material.dart';
import 'package:il_core/il_theme.dart';
import 'package:il_reports/src/models/asset_heatmap_data.dart';
import 'package:il_reports/src/ui/widgets/asset_heatmap_painter.dart';

class HeatmapReportWidget extends StatefulWidget {
  final AssetHeatmapData data;

  const HeatmapReportWidget({super.key, required this.data});

  @override
  State<HeatmapReportWidget> createState() => _HeatmapReportWidgetState();
}

class _HeatmapReportWidgetState extends State<HeatmapReportWidget> {
  var transformationController = TransformationController();
  late AssetHeatmapData data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  void didUpdateWidget(covariant HeatmapReportWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryBlueColor,
            width: 2,
          ),
          color: Colors.grey.shade200,
        ),
        child: InteractiveViewer(
          transformationController: transformationController,
          constrained: false,
          minScale: 0.01,
          maxScale: 2,
          boundaryMargin: const EdgeInsets.all(500),
          child: buildHeatmapPaint(),
        ),
      );
    });
  }

  Widget buildHeatmapPaint() {
    return CustomPaint(
      willChange: false,
      isComplex: true,
      size: data.floorMap.size,
      painter: AssetHeatmapPainter(data),
    );
  }

  @override
  void dispose() {
    transformationController.dispose();
    super.dispose();
  }
}
