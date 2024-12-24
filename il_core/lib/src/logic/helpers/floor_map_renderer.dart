import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:il_core/il_entities.dart';

class FloorMapRenderer {
  Matrix4 transform = Matrix4.identity();

  void drawFloorMapSvg(Canvas canvas, Size size, PictureInfo svg) {
    var paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.color = Color.fromARGB(255, 255, 255, 255);

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawPicture(svg.picture);
  }

  void drawZones(Canvas canvas, FloorMap floorMap) {
    var zones = floorMap.zones!;

    var paint = Paint();
    paint.style = PaintingStyle.fill;

    for (var zone in zones) {
      var points = zone.points;

      var color = zone.color.withOpacity(0.2);
      paint.color = color;

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
