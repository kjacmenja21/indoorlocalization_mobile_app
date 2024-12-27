import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:il_core/il_theme.dart';
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
          child: _TailmapReportWidget(data: data),
        ),
      ],
    );
  }
}

class _TailmapReportWidget extends StatefulWidget {
  final AssetTailmapData data;

  const _TailmapReportWidget({required this.data});

  @override
  State<_TailmapReportWidget> createState() => _TailmapReportWidgetState();
}

class _TailmapReportWidgetState extends State<_TailmapReportWidget> {
  var transformationController = TransformationController();

  late AssetTailmapData data;
  PictureInfo? floorMapSvg;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    loadSvg(data.floorMap.svgImage);
  }

  @override
  void didUpdateWidget(_TailmapReportWidget oldWidget) {
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
              child: buildTailmapBackground(),
            ),
            IgnorePointer(
              child: ListenableBuilder(
                listenable: transformationController,
                builder: (context, child) {
                  return buildTailmapForeground(
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

  Widget buildTailmapBackground() {
    return CustomPaint(
      willChange: false,
      isComplex: true,
      size: data.floorMap.size,
      painter: AssetTailmapBackgroundPainter(
        data: data,
        svg: floorMapSvg!,
      ),
    );
  }

  Widget buildTailmapForeground(Size size, Matrix4 transform) {
    return ClipRect(
      child: CustomPaint(
        willChange: true,
        size: size,
        painter: AssetTailmapForegroundPainter(
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
