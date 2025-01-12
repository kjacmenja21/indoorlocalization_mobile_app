import 'package:flutter/material.dart';
import 'package:il_core/il_ui_helpers.dart';
import 'package:il_reports/src/models/asset_heatmap_data.dart';
import 'package:il_reports/src/ui/helpers/heatmap_renderer.dart';

class AssetHeatmapBackgroundPainter extends CustomPainter {
  final AssetHeatmapData data;
  final IFloorMapImageRenderer imageRenderer;

  late FloorMapRenderer floorMapRenderer;
  late HeatmapRenderer heatmapRenderer;

  AssetHeatmapBackgroundPainter({
    required this.data,
    required this.imageRenderer,
  }) {
    floorMapRenderer = FloorMapRenderer();
    heatmapRenderer = HeatmapRenderer();
  }

  @override
  void paint(Canvas canvas, Size size) {
    imageRenderer.draw(canvas);
    floorMapRenderer.drawZones(canvas, data.floorMap, fill: false);
    heatmapRenderer.drawHeatmap(canvas, data.heatmapData);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is AssetHeatmapBackgroundPainter) {
      return data != oldDelegate.data || imageRenderer != oldDelegate.imageRenderer;
    }
    return false;
  }
}

class AssetHeatmapForegroundPainter extends CustomPainter {
  final Matrix4 transform;
  final AssetHeatmapData data;

  late FloorMapRenderer floorMapRenderer;
  late HeatmapRenderer heatmapRenderer;

  AssetHeatmapForegroundPainter({
    required this.transform,
    required this.data,
  }) {
    floorMapRenderer = FloorMapRenderer();
    floorMapRenderer.transform = transform;

    heatmapRenderer = HeatmapRenderer();
  }

  @override
  void paint(Canvas canvas, Size size) {
    floorMapRenderer.drawZoneLabels(canvas, data.floorMap);

    var lPadding = const EdgeInsets.only(top: 20, bottom: 20, right: 20);
    var lSize = Size(10, size.height - lPadding.vertical);
    var lRect = Rect.fromLTWH(
      size.width - lSize.width - lPadding.right,
      lPadding.top,
      lSize.width,
      lSize.height,
    );

    heatmapRenderer.drawLegend(canvas, lRect, data.heatmapData);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is AssetHeatmapForegroundPainter) {
      return data != oldDelegate.data;
    }
    return false;
  }
}
