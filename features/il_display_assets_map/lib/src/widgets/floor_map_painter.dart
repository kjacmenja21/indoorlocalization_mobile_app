import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_ui_helpers.dart';

class FloorMapPainter extends CustomPainter {
  final FloorMap floorMap;
  final PictureInfo svg;

  late FloorMapRenderer floorMapRenderer;

  FloorMapPainter({
    required this.floorMap,
    required this.svg,
  }) {
    floorMapRenderer = FloorMapRenderer();
  }

  @override
  void paint(Canvas canvas, Size size) {
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
