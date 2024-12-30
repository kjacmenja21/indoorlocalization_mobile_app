import 'package:flutter/painting.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_helpers.dart';

class AssetHeatmapCell {
  double minutes = 0;
  double percentage = 0;
}

class AssetHeatmapData {
  Asset asset;
  late FloorMap floorMap;

  DateTime startDate;
  DateTime endDate;

  LinearGradient gradient;

  Size _mapSize = Size.zero;
  Size _cellSize = Size.zero;

  int _rows = 0;
  int _columns = 0;
  List<AssetHeatmapCell> _cells = [];

  AssetHeatmapData({
    required this.asset,
    required this.startDate,
    required this.endDate,
    required this.gradient,
  }) {
    floorMap = asset.floorMap!;
  }

  Color getCellColor(AssetHeatmapCell cell) {
    double p = cell.percentage;

    if (p < 0.01) {
      return const Color.fromARGB(0, 0, 0, 0);
    }

    var gradient = this.gradient!;

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

  void generateCells(Size cellSize) {
    if (cellSize.shortestSide < 10) {
      throw ArgumentError('Cell size must be >= 10.');
    }

    _cellSize = cellSize;
    Size floorMapSize = floorMap.size;

    _columns = (floorMapSize.width / _cellSize.width).floor();
    _rows = (floorMapSize.height / _cellSize.height).floor();

    int cellCount = _rows * _columns;
    _cells = List.generate(cellCount, (index) => AssetHeatmapCell(), growable: false);

    _mapSize = Size(_columns * _cellSize.width, _rows * _cellSize.height);
  }

  Size get mapSize => _mapSize;
  Size get cellSize => _cellSize;

  List<AssetHeatmapCell> get cells => _cells;

  AssetHeatmapCell cellAt(int x, int y) {
    return _cells[x + y * _columns];
  }

  AssetHeatmapCell cellFromPosition(double x, double y) {
    int cx = (x / _cellSize.width).floor();
    int cy = (y / _cellSize.height).floor();

    return _cells[cx + cy * _columns];
  }
}
