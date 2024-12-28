import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_ui_helpers.dart';

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

    Rect trackingArea = floorMap.trackingArea;

    for (var asset in assets) {
      double ax = asset.x + trackingArea.left;
      double ay = asset.y + trackingArea.top;

      floorMapRenderer.drawAsset(canvas, asset.name, Offset(ax, ay));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
