import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:il_core/il_helpers.dart';
import 'package:il_core/il_ui_helpers.dart';
import 'package:il_reports/src/models/asset_heatmap_data.dart';

class AssetHeatmapBackgroundPainter extends CustomPainter {
  final AssetHeatmapData data;
  final PictureInfo svg;

  late FloorMapRenderer floorMapRenderer;

  AssetHeatmapBackgroundPainter({
    required this.data,
    required this.svg,
  }) {
    floorMapRenderer = FloorMapRenderer();
  }

  @override
  void paint(Canvas canvas, Size size) {
    floorMapRenderer.drawFloorMapSvg(canvas, size, svg);
    floorMapRenderer.drawZones(canvas, data.floorMap, fill: false);
    _drawHeatmap(canvas);
  }

  void _drawHeatmap(Canvas canvas) {
    var paint = Paint();
    paint.style = PaintingStyle.fill;

    double mapWidth = data.mapSize.width;
    double mapHeight = data.mapSize.height;

    double cellWidth = data.cellSize.width;
    double cellHeight = data.cellSize.height;

    int i = 0;
    for (double y = 0; y < mapHeight; y += cellHeight) {
      for (double x = 0; x < mapWidth; x += cellWidth) {
        var cell = data.cells[i];
        paint.color = _getCellColor(cell);

        canvas.drawCircle(Offset(x + cellWidth / 2, y + cellHeight / 2), cellWidth / 2 - 4, paint);
        i++;
      }
    }
  }

  Color _getCellColor(AssetHeatmapCell cell) {
    double minutes = cell.minutes;

    if (minutes <= 60) {
      var a = MathHelper.lerpDouble(0, 255, minutes / 60).round();
      if (a > 255) a = 255;
      return Color.fromARGB(a, 255, 153, 0);
    }

    return Color.fromARGB(255, 255, 153, 0);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is AssetHeatmapBackgroundPainter) {
      return data != oldDelegate.data || svg != oldDelegate.svg;
    }
    return false;
  }
}

class AssetHeatmapForegroundPainter extends CustomPainter {
  final Matrix4 transform;
  final AssetHeatmapData data;

  late FloorMapRenderer floorMapRenderer;

  AssetHeatmapForegroundPainter({
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
    if (oldDelegate is AssetHeatmapForegroundPainter) {
      return data != oldDelegate.data;
    }
    return false;
  }
}
