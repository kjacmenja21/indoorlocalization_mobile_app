import 'dart:ui';

import 'package:il_core/il_entities.dart';

class AssetTailmapData {
  final Asset asset;
  late final FloorMap floorMap;

  final DateTime startDate;
  final DateTime endDate;

  final List<AssetPositionHistory> positionHistory;

  int _currentPositionIndex = 0;

  AssetTailmapData({
    required this.asset,
    required this.startDate,
    required this.endDate,
    required this.positionHistory,
  }) {
    floorMap = asset.floorMap!;
    _currentPositionIndex = positionHistory.length - 1;
  }

  int get currentPositionIndex => _currentPositionIndex;

  set currentPositionIndex(int value) {
    if (value < 0) {
      value = 0;
    } else if (value >= positionHistory.length) {
      value = positionHistory.length - 1;
    }

    _currentPositionIndex = value;
  }

  Offset get currentPosition {
    var pos = positionHistory[_currentPositionIndex];
    return Offset(pos.x, pos.y);
  }

  DateTime get currentDate {
    return positionHistory[_currentPositionIndex].timestamp;
  }
}
