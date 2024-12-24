import 'package:flutter/material.dart';
import 'package:il_reports/src/models/asset_heatmap_data.dart';

class AssetHeatmapPainter extends CustomPainter {
  final AssetHeatmapData data;

  AssetHeatmapPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    double mapWidth = data.mapSize.width;
    double mapHeight = data.mapSize.height;

    double cellWidth = data.cellSize.width;
    double cellHeight = data.cellSize.height;

    int i = 0;
    for (double y = 0; y < mapHeight; y += cellHeight) {
      for (double x = 0; x < mapWidth; x += cellWidth) {
        var cell = data.cells[i];
        paint.color = getCellColor(cell);

        canvas.drawCircle(Offset(x + cellWidth / 2, y + cellHeight / 2), cellWidth / 2 - 4, paint);
        i++;
      }
    }
  }

  Color getCellColor(AssetHeatmapCell cell) {
    double minutes = cell.minutes;

    if (minutes <= 60) {
      var a = lerpDouble(0, 255, minutes / 60).round();
      if (a > 255) a = 255;
      return Color.fromARGB(a, 255, 153, 0);
    }

    return Color.fromARGB(255, 255, 153, 0);
  }

  double lerpDouble(double a, double b, double t) {
    return a * (1.0 - t) + b * t;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is AssetHeatmapPainter) {
      return data != oldDelegate.data;
    }
    return false;
  }
}
