import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_theme.dart';

class FloorMapRenderer {
  Matrix4 transform = Matrix4.identity();

  void drawAsset(Canvas canvas, String name, Offset position) {
    const double assetCircleRadius = 4.0;
    const double labelBottomMargin = 10;
    const double labelFontSize = 16;

    // transform asset position

    double scale = transform.getMaxScaleOnAxis();
    var translation = transform.getTranslation();

    double ax = position.dx * scale + translation.x;
    double ay = position.dy * scale + translation.y;
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
        text: name,
        style: const TextStyle(color: Colors.white, fontSize: labelFontSize),
      ),
    );

    textPainter.layout();

    var labelPosition = assetPosition - Offset(textPainter.width / 2, textPainter.height + labelBottomMargin);
    var labelRectPosition = labelPosition - const Offset(12, 2);
    var labelRectSize = Offset(textPainter.width + 24, textPainter.height + 4);

    drawRRect(canvas, labelRectPosition, labelRectSize, labelRectSize.dy / 2, paint);
    textPainter.paint(canvas, labelPosition);
  }

  void drawZones(Canvas canvas, FloorMap floorMap, {bool fill = true}) {
    var zones = floorMap.zones!;

    var paint = Paint();
    paint.style = fill ? PaintingStyle.fill : PaintingStyle.stroke;

    if (!fill) {
      paint.strokeWidth = 4;
    }

    for (var zone in zones) {
      var points = zone.points;

      if (fill) {
        paint.color = zone.color.withValues(alpha: 0.2);
      } else {
        paint.color = Color.fromARGB(255, 0, 0, 0);
      }

      var path = Path();

      for (int i = 0; i < points.length; i++) {
        var p = points[i];

        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }

      path.close();
      canvas.drawPath(path, paint);
    }
  }

  void drawZoneLabels(Canvas canvas, FloorMap floorMap) {
    const double labelFontSize = 16;
    var zones = floorMap.zones!;

    for (var zone in zones) {
      // transform zone label position

      double scale = transform.getMaxScaleOnAxis();
      var translation = transform.getTranslation();

      Rect trackingArea = floorMap.trackingArea;

      double zx = zone.labelPoint.dx + trackingArea.left;
      double zy = zone.labelPoint.dy + trackingArea.top;

      double tx = zx * scale + translation.x;
      double ty = zy * scale + translation.y;

      // draw zone name

      var textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: zone.name,
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: labelFontSize),
        ),
      );

      textPainter.layout();
      ty -= textPainter.height;

      textPainter.paint(canvas, Offset(tx, ty));
    }
  }

  void drawRRect(Canvas canvas, Offset pos, Offset size, double r, Paint paint) {
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(pos.dx, pos.dy, size.dx, size.dy), r, r), paint);
  }
}
