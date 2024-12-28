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
    floorMapRenderer.drawZones(canvas, data.floorMap);
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
    _drawPath(canvas);
  }

  void _drawPath(Canvas canvas) {
    double scale = transform.getMaxScaleOnAxis();
    var translation = transform.getTranslation();

    Rect trackingArea = data.floorMap.trackingArea;

    var positionHistory = data.positionHistory;

    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.orange;
    paint.strokeWidth = 2;

    var path = Path();

    for (int i = 0; i < positionHistory.length; i++) {
      var posHistory = positionHistory[i];
      double px = posHistory.x + trackingArea.left;
      double py = posHistory.y + trackingArea.top;

      double x = px * scale + translation.x;
      double y = py * scale + translation.y;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    var lastPos = positionHistory.last;
    double lx = lastPos.x + trackingArea.left;
    double ly = lastPos.y + trackingArea.top;

    floorMapRenderer.drawAsset(canvas, data.asset.name, Offset(lx, ly));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is AssetTailmapForegroundPainter) {
      return data != oldDelegate.data;
    }
    return false;
  }
}
