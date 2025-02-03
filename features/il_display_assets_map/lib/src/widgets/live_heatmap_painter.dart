import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_ui_helpers.dart';
import 'package:il_reports/il_heatmap.dart';

class LiveHeatmapBackgroundPainter extends CustomPainter {
  final FloorMap floorMap;
  final IFloorMapImageRenderer imageRenderer;

  final HeatmapData? heatmapData;

  late FloorMapRenderer floorMapRenderer;
  late HeatmapRenderer heatmapRenderer;

  LiveHeatmapBackgroundPainter({
    required this.floorMap,
    required this.imageRenderer,
    this.heatmapData,
  }) {
    floorMapRenderer = FloorMapRenderer();
    heatmapRenderer = HeatmapRenderer();
  }

  @override
  void paint(Canvas canvas, Size size) {
    imageRenderer.draw(canvas);
    floorMapRenderer.drawZones(canvas, floorMap);

    if (heatmapData != null) {
      heatmapRenderer.drawHeatmap(canvas, heatmapData!);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is LiveHeatmapBackgroundPainter) {
      return floorMap != oldDelegate.floorMap || heatmapData != oldDelegate.heatmapData;
    }
    return false;
  }
}

class LiveHeatmapForegroundPainter extends CustomPainter {
  final Matrix4 transform;
  final FloorMap floorMap;
  final List<Asset> assets;
  final HeatmapData? heatmapData;

  late FloorMapRenderer floorMapRenderer;
  late HeatmapRenderer heatmapRenderer;

  LiveHeatmapForegroundPainter({
    required this.transform,
    required this.floorMap,
    required this.assets,
    this.heatmapData,
  }) {
    floorMapRenderer = FloorMapRenderer();
    floorMapRenderer.transform = transform;

    heatmapRenderer = HeatmapRenderer();
  }

  @override
  void paint(Canvas canvas, Size size) {
    floorMapRenderer.drawZoneLabels(canvas, floorMap);
    _drawHeatmapLegend(canvas, size);

    Rect trackingArea = floorMap.trackingArea;

    for (var asset in assets) {
      double ax = asset.x + trackingArea.left;
      double ay = asset.y + trackingArea.top;

      floorMapRenderer.drawAsset(canvas, asset.name, Offset(ax, ay));
    }
  }

  void _drawHeatmapLegend(Canvas canvas, Size size) {
    if (heatmapData != null) {
      var lPadding = const EdgeInsets.only(top: 20, bottom: 20, right: 20);
      var lSize = Size(10, size.height - lPadding.vertical);
      var lRect = Rect.fromLTWH(
        size.width - lSize.width - lPadding.right,
        lPadding.top,
        lSize.width,
        lSize.height,
      );

      heatmapRenderer.drawLegend(canvas, lRect, heatmapData!);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
