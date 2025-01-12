import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_theme.dart';
import 'package:il_core/src/ui/helpers/floor_map_image_renderer.dart';

class FloorMapWidget extends StatefulWidget {
  final FloorMap floorMap;

  final void Function(TapDownDetails details, Matrix4 transform)? onDoubleTapDown;

  final CustomPaint Function(IFloorMapImageRenderer imageRenderer) backgroundBuilder;
  final CustomPaint Function(Size size, Matrix4 transform) foregroundBuilder;
  final Widget? child;

  const FloorMapWidget({
    super.key,
    required this.floorMap,
    this.onDoubleTapDown,
    required this.backgroundBuilder,
    required this.foregroundBuilder,
    this.child,
  });

  @override
  State<FloorMapWidget> createState() => _FloorMapWidgetState();
}

class _FloorMapWidgetState extends State<FloorMapWidget> {
  var transformationController = TransformationController();

  late IFloorMapImageRenderer imageRenderer;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    imageRenderer = IFloorMapImageRenderer.fromFloorMap(widget.floorMap);
    loadImage();
  }

  @override
  void didUpdateWidget(FloorMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.floorMap != oldWidget.floorMap) {
      imageRenderer = IFloorMapImageRenderer.fromFloorMap(widget.floorMap);
      loadImage();
    }
  }

  Future<void> loadImage() async {
    setState(() => isLoading = true);
    await imageRenderer.load();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
                child: widget.backgroundBuilder(imageRenderer),
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
            if (widget.child != null) widget.child!,
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    transformationController.dispose();
    imageRenderer.dispose();
    super.dispose();
  }
}
