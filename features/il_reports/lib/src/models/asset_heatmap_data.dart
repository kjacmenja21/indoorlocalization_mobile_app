import 'dart:ui';

import 'package:il_core/il_entities.dart';
import 'package:il_core/il_helpers.dart';

class AssetHeatmapCell {
  double minutes = 0;
  double p = 0;
}

class AssetHeatmapData {
  Asset asset;
  late FloorMap floorMap;

  DateTime? startDate;
  DateTime? endDate;

  late Size mapSize = Size.zero;
  Size cellSize = Size.zero;

  int rows = 0;
  int columns = 0;

  List<AssetHeatmapCell> cells = [];

  AssetHeatmapData(this.asset) {
    floorMap = asset.floorMap!;
  }

  Color getCellColor(AssetHeatmapCell cell) {
    double p = cell.p;

    if (p < 0.001) {
      return const Color.fromARGB(0, 0, 0, 0);
    }

    if (p <= 0.4) {
      var a = MathHelper.lerpDouble(20, 255, p / 0.4).round();
      return const Color.fromARGB(255, 255, 196, 0).withAlpha(a);
    }

    if (p <= 0.9) {
      var c = MathHelper.lerpColor(
        const Color.fromARGB(255, 255, 196, 0),
        const Color.fromARGB(255, 255, 0, 0),
        (p - 0.4) / 0.5,
      );
      return c;
    }

    return const Color.fromARGB(255, 255, 0, 0);
  }

  AssetHeatmapCell cellAt(int x, int y) {
    return cells[x + y * columns];
  }

  AssetHeatmapCell cellFromPosition(double x, double y) {
    int cx = (x / cellSize.width).floor();
    int cy = (y / cellSize.height).floor();

    return cells[cx + cy * columns];
  }
}
