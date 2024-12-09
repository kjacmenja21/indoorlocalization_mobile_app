import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_theme.dart';
import 'package:il_display_assets_map/src/widgets/assets_painter.dart';
import 'package:il_display_assets_map/src/widgets/floor_map_painter.dart';

class AssetsWidget extends StatefulWidget {
  final FloorMap floorMap;
  final List<Asset> assets;

  const AssetsWidget({
    super.key,
    required this.floorMap,
    required this.assets,
  });

  @override
  State<AssetsWidget> createState() => _AssetsWidgetState();
}

class _AssetsWidgetState extends State<AssetsWidget> {
  var transformationController = TransformationController();

  late FloorMap floorMap;
  late List<Asset> assets;

  PictureInfo? floorMapSvg;

  @override
  void initState() {
    super.initState();
    floorMap = widget.floorMap;
    assets = widget.assets;
    loadSvg(floorMap.svgImage);
  }

  @override
  Widget build(BuildContext context) {
    if (floorMapSvg == null) {
      return Container();
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
        ),
        child: Stack(
          children: [
            InteractiveViewer(
              transformationController: transformationController,
              constrained: false,
              minScale: 0.001,
              maxScale: 20,
              boundaryMargin: const EdgeInsets.all(500),
              child: buildFloorMapPaint(),
            ),
            IgnorePointer(
              child: ListenableBuilder(
                listenable: transformationController,
                builder: (context, child) {
                  return buildAssetsPaint(
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

  Widget buildFloorMapPaint() {
    return CustomPaint(
      willChange: false,
      isComplex: true,
      size: floorMap.size,
      painter: FloorMapPainter(
        floorMap: floorMap,
        svg: floorMapSvg!,
      ),
    );
  }

  Widget buildAssetsPaint(Size size, Matrix4 transform) {
    return ClipRect(
      child: CustomPaint(
        willChange: true,
        size: size,
        painter: AssetsPainter(
          transform: transform,
          floorMap: floorMap,
          assets: assets,
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
