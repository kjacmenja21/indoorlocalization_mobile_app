import 'package:flutter/painting.dart';
import 'package:il_core/il_helpers.dart';

class HeatmapCell {
  double minutes = 0;
  double percentage = 0;
}

class HeatmapData {
  static const defaultGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Color.fromARGB(0, 255, 196, 0),
      Color.fromARGB(255, 255, 196, 0),
      Color.fromARGB(255, 255, 0, 0),
      Color.fromARGB(255, 255, 0, 0),
    ],
    stops: [
      0.0,
      0.4,
      0.9,
      1.0,
    ],
  );

  DateTime startDate;
  DateTime endDate;

  LinearGradient gradient;

  Size _mapSize = Size.zero;
  Size _cellSize = Size.zero;

  int _rows = 0;
  int _columns = 0;
  List<HeatmapCell> _cells = [];

  HeatmapData({
    required this.startDate,
    required this.endDate,
    required this.gradient,
  });

  Color getCellColor(HeatmapCell cell) {
    double p = cell.percentage;

    if (p < 0.01) {
      return const Color.fromARGB(0, 0, 0, 0);
    }

    var gradient = this.gradient;

    for (int i = 1; i < gradient.stops!.length; i++) {
      double sp1 = gradient.stops![i - 1];
      double sp2 = gradient.stops![i];

      if (p <= sp2) {
        double t = (p - sp1) / (sp2 - sp1);

        Color c1 = gradient.colors[i - 1];
        Color c2 = gradient.colors[i];

        var c = MathHelper.lerpColor(c1, c2, t);
        return c;
      }
    }

    return gradient.colors.last;
  }

  void generateCells(Size totalMapSize, Size cellSize) {
    if (cellSize.shortestSide < 10) {
      throw ArgumentError('Cell size must be >= 10.');
    }

    _cellSize = cellSize;

    _columns = (totalMapSize.width / _cellSize.width).floor();
    _rows = (totalMapSize.height / _cellSize.height).floor();

    int cellCount = _rows * _columns;
    _cells = List.generate(cellCount, (index) => HeatmapCell(), growable: false);

    _mapSize = Size(_columns * _cellSize.width, _rows * _cellSize.height);
  }

  Size get mapSize => _mapSize;
  Size get cellSize => _cellSize;

  List<HeatmapCell> get cells => _cells;

  HeatmapCell cellAt(int x, int y) {
    x = _clampCellIndex(x, _columns);
    y = _clampCellIndex(y, _rows);
    return _cells[x + y * _columns];
  }

  HeatmapCell cellFromPosition(double x, double y) {
    int cx = (x / _cellSize.width).floor();
    int cy = (y / _cellSize.height).floor();

    cx = _clampCellIndex(cx, _columns);
    cy = _clampCellIndex(cy, _rows);

    return _cells[cx + cy * _columns];
  }

  int _clampCellIndex(int c, int max) {
    if (c < 0) {
      return 0;
    } else if (c >= max) {
      return max - 1;
    }

    return c;
  }
}
