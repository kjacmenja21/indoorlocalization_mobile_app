import 'package:flutter/rendering.dart';
import 'package:il_reports/il_heatmap.dart';

class HeatmapRenderer {
  void drawHeatmap(Canvas canvas, HeatmapData data) {
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

  void drawLegend(Canvas canvas, Rect lRect, HeatmapData data) {
    var paint = Paint();

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
}
