import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_reports/src/logic/asset_zone_retention_data_generator.dart';

void main() {
  var generator = AssetZoneRetentionDataGenerator(asset: createAsset());

  group('generate()', () {
    test('given zone history data, generates zone retention data', () {
      generator.zones = [
        createZone(1),
        createZone(2),
        createZone(3),
        createZone(4),
      ];

      generator.zoneHistoryData = [
        createZoneHistory(1, '08:00', '10:00'),
        createZoneHistory(2, '11:00', '12:00'),
        createZoneHistory(3, '12:00', '13:00'),
        createZoneHistory(4, '14:00', '16:00'),
      ];

      var data = generator.generate();

      var z0 = data.zoneRetentionData.firstWhere((e) => e.zoneId == 0);
      var z1 = data.zoneRetentionData.firstWhere((e) => e.zoneId == 1);
      var z2 = data.zoneRetentionData.firstWhere((e) => e.zoneId == 2);
      var z3 = data.zoneRetentionData.firstWhere((e) => e.zoneId == 3);
      var z4 = data.zoneRetentionData.firstWhere((e) => e.zoneId == 4);

      expect(z0.retention.inHours, 2);
      expect(z1.retention.inHours, 2);
      expect(z2.retention.inHours, 1);
      expect(z3.retention.inHours, 1);
      expect(z4.retention.inHours, 2);

      expect(z0.percentage, 2 / 8);
      expect(z1.percentage, 2 / 8);
      expect(z2.percentage, 1 / 8);
      expect(z3.percentage, 1 / 8);
      expect(z4.percentage, 2 / 8);
    });
  });
}

Asset createAsset() {
  return Asset(
    id: 0,
    name: '',
    x: 0,
    y: 0,
    lastSync: DateTime.now(),
    active: true,
    floorMapId: 0,
  );
}

FloorMapZone createZone(int zoneId) {
  return FloorMapZone(
    id: zoneId,
    name: '',
    color: const Color.fromARGB(255, 255, 255, 255),
    points: [],
    floorMapId: 0,
  );
}

AssetZoneHistory createZoneHistory(int zoneId, String enterTime, String exitTime) {
  return AssetZoneHistory(
    id: 0,
    assetId: 0,
    zoneId: zoneId,
    enterDateTime: DateTime.parse('2024-10-01 $enterTime'),
    exitDateTime: DateTime.parse('2024-10-01 $exitTime'),
  );
}
