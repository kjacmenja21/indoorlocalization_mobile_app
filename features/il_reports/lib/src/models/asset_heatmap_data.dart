import 'dart:ui';

import 'package:il_core/il_entities.dart';

class AssetHeatmapCell {
  double minutes = 0;
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

  AssetHeatmapCell cellAt(int x, int y) {
    return cells[x + y * columns];
  }

  AssetHeatmapCell cellFromPosition(double x, double y) {
    int cx = (x / cellSize.width).floor();
    int cy = (y / cellSize.height).floor();

    return cells[cx + cy * columns];
  }
}
