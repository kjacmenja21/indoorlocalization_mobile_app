import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:il_core/il_helpers.dart';
import 'package:il_core/il_theme.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssetReportInfo(
          asset: data.asset,
          startDate: data.startDate!,
          endDate: data.endDate!,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: _HeatmapReportWidget(data: data),
        ),
      ],
    );
  }
}

class _HeatmapReportWidget extends StatefulWidget {
  final AssetHeatmapData data;

  const _HeatmapReportWidget({required this.data});

  @override
  State<_HeatmapReportWidget> createState() => _HeatmapReportWidgetState();
}

class _HeatmapReportWidgetState extends State<_HeatmapReportWidget> {
  var transformationController = TransformationController();

  late AssetHeatmapData data;
  PictureInfo? floorMapSvg;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    loadSvg(data.floorMap.svgImage);
  }

  @override
  void didUpdateWidget(covariant _HeatmapReportWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    if (floorMapSvg == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

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
        child: Stack(
          children: [
            InteractiveViewer(
              transformationController: transformationController,
              constrained: false,
              minScale: 0.01,
              maxScale: 2,
              boundaryMargin: const EdgeInsets.all(500),
              child: buildHeatmapBackground(),
            ),
            IgnorePointer(
              child: ListenableBuilder(
                listenable: transformationController,
                builder: (context, child) {
                  return buildHeatmapForeground(
                    constraints.biggest,
                    transformationController.value,
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildHeatmapBackground() {
    return CustomPaint(
      willChange: false,
      isComplex: true,
      size: data.floorMap.size,
      painter: AssetHeatmapBackgroundPainter(
        data: data,
        svg: floorMapSvg!,
      ),
    );
  }

  Widget buildHeatmapForeground(Size size, Matrix4 transform) {
    return ClipRect(
      child: CustomPaint(
        willChange: true,
        size: size,
        painter: AssetHeatmapForegroundPainter(
          transform: transform,
          data: data,
        ),
      ),
    );
  }

  Future<void> loadSvg(String svgText) async {
    var svg = await vg.loadPicture(SvgStringLoader(svgText), null);
    setState(() => floorMapSvg = svg);
  }

  @override
  void dispose() {
    transformationController.dispose();
    super.dispose();
  }
}
