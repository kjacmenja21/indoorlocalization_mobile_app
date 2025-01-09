import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_ui_helpers.dart';

class AssetsBackgroundPainter extends CustomPainter {
  final FloorMap floorMap;
  final IFloorMapImageRenderer imageRenderer;

  late FloorMapRenderer floorMapRenderer;

  AssetsBackgroundPainter({
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
    if (oldDelegate is AssetsBackgroundPainter) {
      return floorMap != oldDelegate.floorMap;
    }
    return false;
  }
}

class AssetsForegroundPainter extends CustomPainter {
  final Matrix4 transform;
  final FloorMap floorMap;
  final List<Asset> assets;

  late FloorMapRenderer floorMapRenderer;

  AssetsForegroundPainter({
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
