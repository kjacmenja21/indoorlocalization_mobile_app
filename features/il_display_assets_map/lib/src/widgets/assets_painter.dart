import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_helpers.dart';
import 'package:il_core/il_theme.dart';

class AssetsPainter extends CustomPainter {
  final Matrix4 transform;
  final FloorMap floorMap;
  final List<Asset> assets;

  late FloorMapRenderer floorMapRenderer;

  AssetsPainter({
    required this.transform,
    required this.floorMap,
    required this.assets,
  }) {
    floorMapRenderer = FloorMapRenderer();
    floorMapRenderer.transform = transform;
  }

  @override
  void paint(Canvas canvas, Size size) {
    floorMapRenderer.drawZoneLabels(canvas, floorMap);

    for (var asset in assets) {
      drawAsset(asset, canvas);
    }
  }

  void drawAsset(Asset asset, Canvas canvas) {
    const double assetCircleRadius = 4.0;
    const double labelBottomMargin = 10;
    const double labelFontSize = 16;

    // transform asset position

    double scale = transform.getMaxScaleOnAxis();
    var translation = transform.getTranslation();

    Rect trackingArea = floorMap.trackingArea;

    double ax = asset.x + trackingArea.left;
    double ay = asset.y + trackingArea.top;

    double tx = ax * scale + translation.x;
    double ty = ay * scale + translation.y;
    Offset assetPosition = Offset(tx, ty);

    // draw position circle

    Paint paint = Paint();
    paint.color = AppColors.primaryBlueColor;
    paint.style = PaintingStyle.fill;

    canvas.drawCircle(assetPosition, assetCircleRadius, paint);

    // draw asset name

    var textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: asset.name,
        style: const TextStyle(color: Colors.white, fontSize: labelFontSize),
      ),
    );

    textPainter.layout();

    var labelPosition = assetPosition - Offset(textPainter.width / 2, textPainter.height + labelBottomMargin);
    var labelRectPosition = labelPosition - const Offset(12, 2);
    var labelRectSize = Offset(textPainter.width + 24, textPainter.height + 4);

    floorMapRenderer.drawRRect(canvas, labelRectPosition, labelRectSize, labelRectSize.dy / 2, paint);
    textPainter.paint(canvas, labelPosition);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
