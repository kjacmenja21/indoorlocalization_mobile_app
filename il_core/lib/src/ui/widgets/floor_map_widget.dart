import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_theme.dart';

class FloorMapWidget extends StatefulWidget {
  final FloorMap floorMap;

  final void Function(TapDownDetails details, Matrix4 transform)? onDoubleTapDown;

  final CustomPaint Function(PictureInfo svg) backgroundBuilder;
  final CustomPaint Function(Size size, Matrix4 transform) foregroundBuilder;

  const FloorMapWidget({
    super.key,
    required this.floorMap,
    this.onDoubleTapDown,
    required this.backgroundBuilder,
    required this.foregroundBuilder,
  });

  @override
  State<FloorMapWidget> createState() => _FloorMapWidgetState();
}

class _FloorMapWidgetState extends State<FloorMapWidget> {
  var transformationController = TransformationController();

  late FloorMap floorMap;
  PictureInfo? floorMapSvg;

  @override
  void initState() {
    super.initState();
    floorMap = widget.floorMap;
    loadSvg(floorMap.svgImage);
  }

  @override
  void didUpdateWidget(FloorMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (floorMap != oldWidget.floorMap) {
      floorMap = widget.floorMap;
      floorMapSvg = null;

      loadSvg(floorMap.svgImage);
    }
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
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onDoubleTapDown: (details) {
                widget.onDoubleTapDown?.call(details, transformationController.value);
              },
              child: InteractiveViewer(
                transformationController: transformationController,
                constrained: false,
                minScale: 0.01,
                maxScale: 2,
                boundaryMargin: const EdgeInsets.all(500),
                child: widget.backgroundBuilder(floorMapSvg!),
              ),
            ),
            IgnorePointer(
              child: ListenableBuilder(
                listenable: transformationController,
                builder: (context, child) {
                  return ClipRect(
                    child: widget.foregroundBuilder(
                      constraints.biggest,
                      transformationController.value,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
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
