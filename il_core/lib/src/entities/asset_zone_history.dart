import 'package:il_core/il_entities.dart';

class AssetZoneHistory {
  int id;
  int assetId;
  int zoneId;

  DateTime enterDateTime;
  DateTime exitDateTime;

  FloorMapZone? zone;

  AssetZoneHistory({
    required this.id,
    required this.assetId,
    required this.zoneId,
    required this.enterDateTime,
    required this.exitDateTime,
    this.zone,
  });

  Duration get retentionTime {
    return exitDateTime.difference(enterDateTime);
  }
}
