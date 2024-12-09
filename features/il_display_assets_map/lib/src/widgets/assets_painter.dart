import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_theme.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class AssetsPainter extends CustomPainter {
  final Matrix4 transform;
  final FloorMap floorMap;
  final List<Asset> assets;

  AssetsPainter({
    required this.transform,
    required this.floorMap,
    required this.assets,
  });

  @override
  void paint(Canvas canvas, Size size) {
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
    Vector3 translation = transform.getTranslation();

    double ax = asset.x * scale + translation.x;
    double ay = asset.y * scale + translation.y;
    Offset assetPosition = Offset(ax, ay);

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

    _drawRRect(labelRectPosition, labelRectSize, labelRectSize.dy / 2, canvas, paint);
    textPainter.paint(canvas, labelPosition);
  }

  void _drawRRect(Offset pos, Offset size, double r, Canvas canvas, Paint paint) {
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(pos.dx, pos.dy, size.dx, size.dy), r, r), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
