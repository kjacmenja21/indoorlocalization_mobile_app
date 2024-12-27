import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:il_core/il_ui_helpers.dart';
import 'package:il_reports/src/models/asset_tailmap_data.dart';

class AssetTailmapBackgroundPainter extends CustomPainter {
  final AssetTailmapData data;
  final PictureInfo svg;

  late FloorMapRenderer floorMapRenderer;

  AssetTailmapBackgroundPainter({
    required this.data,
    required this.svg,
  }) {
    floorMapRenderer = FloorMapRenderer();
  }

  @override
  void paint(Canvas canvas, Size size) {
    floorMapRenderer.drawFloorMapSvg(canvas, size, svg);
    floorMapRenderer.drawZones(canvas, data.floorMap, fill: false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is AssetTailmapBackgroundPainter) {
      return data != oldDelegate.data || svg != oldDelegate.svg;
    }
    return false;
  }
}

class AssetTailmapForegroundPainter extends CustomPainter {
  final Matrix4 transform;
  final AssetTailmapData data;

  late FloorMapRenderer floorMapRenderer;

  AssetTailmapForegroundPainter({
    required this.transform,
    required this.data,
  }) {
    floorMapRenderer = FloorMapRenderer();
    floorMapRenderer.transform = transform;
  }

  @override
  void paint(Canvas canvas, Size size) {
    floorMapRenderer.drawZoneLabels(canvas, data.floorMap);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is AssetTailmapForegroundPainter) {
      return data != oldDelegate.data;
    }
    return false;
  }
}
