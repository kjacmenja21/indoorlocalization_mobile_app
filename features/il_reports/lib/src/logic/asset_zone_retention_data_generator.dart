import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_exceptions.dart';
import 'package:il_reports/src/models/asset_zone_retention_data.dart';

class AssetZoneRetentionDataGenerator {
  final Asset asset;

  List<FloorMapZone> zones = [];
  List<AssetZoneHistory> zoneHistoryData = [];

  AssetZoneRetentionDataGenerator({
    required this.asset,
  });

  AssetZoneRetentionReportData generate() {
    if (zoneHistoryData.isEmpty) {
      throw AppException('Cannot generate zone retention report because there is no available data.');
    }

    zoneHistoryData.sort((a, b) => a.enterDateTime.compareTo(b.enterDateTime));

    for (var zoneHistory in zoneHistoryData) {
      zoneHistory.zone = zones.firstWhere((e) => e.id == zoneHistory.zoneId);
    }

    List<AssetZoneRetention> zoneRetentionData = [
      ...zones.map((zone) {
        return AssetZoneRetention.fromZone(zone);
      }),
      getOutsideZone(),
    ];

    getZoneRetentionData(zoneRetentionData, zoneHistoryData);
    calculateRetentionPercentage(zoneRetentionData);

    return AssetZoneRetentionReportData(
      asset: asset,
      startDate: zoneHistoryData.first.enterDateTime,
      endDate: zoneHistoryData.last.exitDateTime,
      zoneHistoryData: zoneHistoryData,
      zoneRetentionData: zoneRetentionData,
    );
  }

  void getZoneRetentionData(List<AssetZoneRetention> zoneRetentionData, List<AssetZoneHistory> zoneHistoryData) {
    AssetZoneHistory? lastZoneHistory;
    AssetZoneRetention outsideZone = zoneRetentionData.lastWhere((e) => e.zoneId == 0);

    for (int i = 0; i < zoneHistoryData.length; i++) {
      var zoneHistory = zoneHistoryData[i];
      var zoneRetention = findAssetZoneRetention(zoneRetentionData, zoneHistory);

      zoneRetention.addRetention(zoneHistory.retentionTime);

      if (i != 0) {
        var outsideZoneRetention = getOutsideZoneRetention(lastZoneHistory!, zoneHistory);
        outsideZone.addRetention(outsideZoneRetention);
      }

      lastZoneHistory = zoneHistory;
    }
  }

  void calculateRetentionPercentage(List<AssetZoneRetention> zoneRetentionData) {
    int totalMinutes = 0;

    for (var e in zoneRetentionData) {
      totalMinutes += e.retention.inMinutes;
    }

    for (var e in zoneRetentionData) {
      e.percentage = e.retention.inMinutes / totalMinutes;
    }
  }

  Duration getOutsideZoneRetention(AssetZoneHistory zone1, AssetZoneHistory zone2) {
    var t1 = zone1.exitDateTime;
    var t2 = zone2.enterDateTime;

    var duration = t2.difference(t1);

    if (duration.isNegative) {
      return const Duration();
    }

    return duration;
  }

  AssetZoneRetention findAssetZoneRetention(List<AssetZoneRetention> zoneRetentionData, AssetZoneHistory zone) {
    return zoneRetentionData.firstWhere((e) => e.zoneId == zone.zoneId);
  }

  AssetZoneRetention getOutsideZone() {
    return AssetZoneRetention(
      zoneId: 0,
      zoneName: 'Outside zone',
      color: Colors.grey.shade200,
    );
  }
}
