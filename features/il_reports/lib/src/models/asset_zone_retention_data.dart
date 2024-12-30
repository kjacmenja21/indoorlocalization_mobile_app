import 'dart:ui';

import 'package:il_core/il_entities.dart';

class AssetZoneRetention {
  final int zoneId;
  final String zoneName;
  final Color color;

  Duration retention = const Duration();
  double percentage = 0;

  AssetZoneRetention({
    required this.zoneId,
    required this.zoneName,
    required this.color,
  });

  AssetZoneRetention.fromZone(FloorMapZone zone)
      : zoneId = zone.id,
        zoneName = zone.name,
        color = zone.color;

  void addRetention(Duration retention) {
    this.retention += retention;
  }
}

class AssetZoneRetentionReportData {
  final Asset asset;

  final DateTime startDate;
  final DateTime endDate;

  List<AssetZoneHistory> zoneHistoryData;
  List<AssetZoneRetention> zoneRetentionData;

  AssetZoneRetentionReportData({
    required this.asset,
    required this.startDate,
    required this.endDate,
    required this.zoneHistoryData,
    required this.zoneRetentionData,
  });
}
