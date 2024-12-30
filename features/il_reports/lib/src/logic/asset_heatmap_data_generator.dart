import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_exceptions.dart';
import 'package:il_core/il_helpers.dart';
import 'package:il_reports/src/models/asset_heatmap_data.dart';

class AssetHeatmapDataGenerator {
  final Asset asset;

  Size cellSize;
  LinearGradient gradient;
  List<AssetPositionHistory> positionHistory = [];

  AssetHeatmapDataGenerator({
    required this.asset,
    required this.cellSize,
    required this.gradient,
  });

  AssetHeatmapData generate() {
    if (positionHistory.isEmpty) {
      throw AppException('Cannot generate heatmap report because there is no available data.');
    }

    sortPositionHistory(positionHistory);

    var data = AssetHeatmapData(
      asset: asset,
      startDate: positionHistory.first.timestamp,
      endDate: positionHistory.last.timestamp,
      gradient: gradient,
    );

    data.generateCells(cellSize);

    AssetPositionHistory lastPos = positionHistory.first;
    AssetHeatmapCell lastCell = data.cellFromPosition(lastPos.x, lastPos.y);

    for (int i = 1; i < positionHistory.length; i++) {
      var pos = positionHistory[i];
      var cell = data.cellFromPosition(pos.x, pos.y);

      addTimeToCells(data, lastCell, cell, lastPos, pos);
      lastPos = pos;
      lastCell = cell;
    }

    calculateCellPercentage(data);
    return data;
  }

  void calculateCellPercentage(AssetHeatmapData data) {
    double maxMinutes = 0;

    for (var cell in data.cells) {
      if (cell.minutes >= maxMinutes) {
        maxMinutes = cell.minutes;
      }
    }

    for (var cell in data.cells) {
      cell.percentage = cell.minutes / maxMinutes;
    }
  }

  void addTimeToCells(AssetHeatmapData data, AssetHeatmapCell c1, AssetHeatmapCell c2, AssetPositionHistory t1, AssetPositionHistory t2) {
    double timeDifference = getTimeDifferenceMinutes(t1, t2);

    if (c1 == c2) {
      c2.minutes += timeDifference;
      return;
    }

    Offset p1 = Offset(t1.x, t1.y);
    Offset p2 = Offset(t2.x, t2.y);

    Set<AssetHeatmapCell> cells = {};
    cells.add(c1);

    double dt = _calculateDt(p1, p2, data.cellSize.shortestSide);

    for (double t = 0; t <= 1; t += dt) {
      Offset p = lerpPosition(p1, p2, t);

      AssetHeatmapCell cell = data.cellFromPosition(p.dx, p.dy);
      cells.add(cell);
    }

    cells.add(c2);

    double part = timeDifference / cells.length;
    for (var cell in cells) {
      cell.minutes += part;
    }
  }

  double getTimeDifferenceMinutes(AssetPositionHistory t1, AssetPositionHistory t2) {
    Duration d = t2.timestamp.difference(t1.timestamp);
    return d.inMinutes.toDouble();
  }

  void sortPositionHistory(List<AssetPositionHistory> positionHistory) {
    positionHistory.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Offset lerpPosition(Offset a, Offset b, double t) {
    return Offset(
      MathHelper.lerpDouble(a.dx, b.dx, t),
      MathHelper.lerpDouble(a.dy, b.dy, t),
    );
  }

  double _calculateDt(Offset p1, Offset p2, double cellSize) {
    double dx = p2.dx - p1.dx;
    double dy = p2.dy - p1.dy;

    double d = math.sqrt(dx * dx + dy * dy);
    double p = 4 * d / cellSize;

    return 1.0 / p;
  }
}
