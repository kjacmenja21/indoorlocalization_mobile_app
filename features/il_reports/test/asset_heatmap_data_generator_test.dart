import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_reports/src/logic/asset_heatmap_data_generator.dart';
import 'package:il_reports/src/models/asset_heatmap_data.dart';

void main() {
  var posHistory = <String, AssetPositionHistory>{
    't1': createPosHistory('10:00', 20, 20),
    't2': createPosHistory('12:30', 40, 40),
    't3': createPosHistory('12:00', 120, 20),
    't4': createPosHistory('10:40', 320, 20),
  };

  group('getTimeDifferenceMinutes', () {
    var generator = AssetHeatmapDataGenerator();

    test('getTimeDifferenceMinutes, given 2 pos history, time diff is correct', () {
      var t1 = posHistory['t1']!;
      var t2 = posHistory['t2']!;

      double minutes = generator.getTimeDifferenceMinutes(t1, t2);

      expect(minutes, 150);
    });
  });

  group('addTimeToCells', () {
    var generator = AssetHeatmapDataGenerator();
    var mapSize = const Size(10000, 10000);
    var cellSize = const Size(100, 100);

    late AssetHeatmapData data;

    setUp(() {
      data = AssetHeatmapData(createAsset(mapSize));
      data.cellSize = cellSize;
      generator.generateCells(data);
    });

    test(
      'addTimeToCells, given 2 pos history in same cell, total period is added to cell',
      () {
        var t1 = posHistory['t1']!;
        var t2 = posHistory['t2']!;

        var c1 = data.cellFromPosition(t1.x, t1.y);
        var c2 = data.cellFromPosition(t2.x, t2.y);

        generator.addTimeToCells(data, c1, c2, t1, t2);

        expect(c1.minutes, 150);
        expect(c2.minutes, 150);
      },
    );

    test(
      'addTimeToCells, given 2 pos history in neighboring cells, part of period is added to each cell',
      () {
        var t1 = posHistory['t1']!;
        var t2 = posHistory['t3']!;

        var c1 = data.cellFromPosition(t1.x, t1.y);
        var c2 = data.cellFromPosition(t2.x, t2.y);

        generator.addTimeToCells(data, c1, c2, t1, t2);

        expect(c1.minutes, 60);
        expect(c2.minutes, 60);
      },
    );

    test(
      'addTimeToCells, given 2 pos history in far cells, part of period is added to each cell',
      () {
        var t1 = posHistory['t1']!;
        var t2 = posHistory['t4']!;

        var c1 = data.cellFromPosition(t1.x, t1.y);
        var c2 = data.cellFromPosition(t2.x, t2.y);

        generator.addTimeToCells(data, c1, c2, t1, t2);

        expect(data.cellAt(0, 0).minutes, 10);
        expect(data.cellAt(1, 0).minutes, 10);
        expect(data.cellAt(2, 0).minutes, 10);
        expect(data.cellAt(3, 0).minutes, 10);
      },
    );
  });
}

Asset createAsset(Size mapSize) {
  return Asset(
    id: 0,
    name: '',
    x: 0,
    y: 0,
    lastSync: DateTime.now(),
    active: true,
    floorMapId: 0,
    floorMap: FloorMap(id: 0, name: '', trackingArea: Rect.zero, size: mapSize, svgImage: ''),
  );
}

AssetPositionHistory createPosHistory(String time, double x, double y) {
  return AssetPositionHistory(id: 0, assetId: 0, x: x, y: y, timestamp: DateTime.parse('2024-10-01 $time'), floorMapId: 0);
}
