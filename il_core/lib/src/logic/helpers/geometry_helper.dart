import 'dart:ui';

class GeometryHelper {
  /// Returns whether a point is contained within the polygon.
  bool polygonContainsPoint({
    required List<Offset> polygon,
    required Offset point,
  }) {
    if (polygon.length < 3) {
      throw ArgumentError('Polygons must contain at least 3 points.');
    }

    double x = point.dx;
    double y = point.dy;
    int intersects = 0;

    for (int i = 0; i < polygon.length; i++) {
      Offset p1 = polygon[i];
      Offset p2 = polygon[(i + 1) % polygon.length];

      double x1 = p1.dx;
      double y1 = p1.dy;

      double x2 = p2.dx;
      double y2 = p2.dy;

      if (((y1 <= y && y < y2) || (y2 <= y && y < y1)) && x < ((x2 - x1) / (y2 - y1) * (y - y1) + x1)) {
        intersects++;
      }
    }

    return intersects % 2 == 1;
  }
}
