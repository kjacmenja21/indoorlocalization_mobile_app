import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        paint.color = data.getCellColor(cell);

        canvas.drawCircle(Offset(x + cellWidth / 2, y + cellHeight / 2), cellWidth / 2 - 4, paint);
        i++;
      }
    }
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
    _drawLegend(canvas, size);
  }

  void _drawLegend(Canvas canvas, Size size) {
    var paint = Paint();

    var lPadding = const EdgeInsets.only(top: 20, bottom: 20, right: 20);
    var lSize = Size(10, size.height - lPadding.vertical);
    var lRect = Rect.fromLTWH(
      size.width - lSize.width - lPadding.right,
      lPadding.top,
      lSize.width,
      lSize.height,
    );

    // draw white rect

    paint.style = PaintingStyle.fill;
    paint.color = const Color.fromARGB(255, 255, 255, 255);
    canvas.drawRect(lRect, paint);

    // draw gradient

    Shader shader = data.gradient.createShader(lRect);
    paint.shader = shader;

    canvas.drawRect(lRect, paint);
    shader.dispose();

    // draw rect border

    paint.color = const Color.fromARGB(255, 0, 0, 0);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.shader = null;

    canvas.drawRect(lRect, paint);

    // draw labels

    Offset start = Offset(lRect.left - 5, lRect.top + lRect.height);

    for (double p = 0; p <= 1.0; p += 0.2) {
      Offset lpos = Offset(start.dx, start.dy - p * lRect.height);

      var textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: '${(p * 100).round()}%',
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 14),
        ),
      );

      textPainter.layout();

      Offset tpos = lpos - Offset(textPainter.width, textPainter.height / 2);
      textPainter.paint(canvas, tpos);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is AssetHeatmapForegroundPainter) {
      return data != oldDelegate.data;
    }
    return false;
  }
}
