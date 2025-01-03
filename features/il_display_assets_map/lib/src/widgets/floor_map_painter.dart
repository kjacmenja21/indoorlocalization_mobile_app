import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_ui_helpers.dart';

class FloorMapPainter extends CustomPainter {
  final FloorMap floorMap;
  final IFloorMapImageRenderer imageRenderer;

  late FloorMapRenderer floorMapRenderer;

  FloorMapPainter({
    required this.floorMap,
    required this.imageRenderer,
  }) {
    floorMapRenderer = FloorMapRenderer();
  }

  @override
  void paint(Canvas canvas, Size size) {
    imageRenderer.draw(canvas);
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
