import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:il_core/il_entities.dart';

class FloorMapPainter extends CustomPainter {
  final FloorMap floorMap;
  final PictureInfo svg;

  FloorMapPainter({
    required this.floorMap,
    required this.svg,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPicture(svg.picture);

    for (var zone in floorMap.zones!) {
      _drawZone(canvas, zone);
    }
  }

  void _drawZone(Canvas canvas, FloorMapZone zone) {
    var points = zone.points;

    var paint = Paint();
    paint.style = PaintingStyle.fill;

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

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is FloorMapPainter) {
      return floorMap != oldDelegate.floorMap;
    }
    return false;
  }
}
