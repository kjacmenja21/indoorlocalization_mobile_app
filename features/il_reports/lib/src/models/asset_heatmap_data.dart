import 'package:flutter/painting.dart';
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
  LinearGradient? gradient;

  AssetHeatmapData(this.asset, [this.gradient]) {
    floorMap = asset.floorMap!;
  }

  Color getCellColor(AssetHeatmapCell cell) {
    double p = cell.p;

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

  AssetHeatmapCell cellAt(int x, int y) {
    return cells[x + y * columns];
  }

  AssetHeatmapCell cellFromPosition(double x, double y) {
    int cx = (x / cellSize.width).floor();
    int cy = (y / cellSize.height).floor();

    return cells[cx + cy * columns];
  }
}
