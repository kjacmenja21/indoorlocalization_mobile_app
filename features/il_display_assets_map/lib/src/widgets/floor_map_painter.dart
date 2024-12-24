import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_helpers.dart';

class FloorMapPainter extends CustomPainter {
  final FloorMap floorMap;
  final PictureInfo svg;

  FloorMapPainter({
    required this.floorMap,
    required this.svg,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var floorMapRenderer = FloorMapRenderer();

    floorMapRenderer.drawFloorMapSvg(canvas, size, svg);
    floorMapRenderer.drawZones(canvas, floorMap);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is FloorMapPainter) {
      return floorMap != oldDelegate.floorMap;
    }
    return false;
  }
}
