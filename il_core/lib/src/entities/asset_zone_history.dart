import 'package:il_core/il_entities.dart';
import 'package:il_core/il_exceptions.dart';

class AssetZoneHistory {
  int id;
  int assetId;
  int zoneId;

  DateTime enterDateTime;
  DateTime? exitDateTime;

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
    if (exitDateTime == null) {
      throw AppException('Can\'t calculate retention time because exit date time is unknown.');
    }

    return exitDateTime!.difference(enterDateTime);
  }

  factory AssetZoneHistory.fromJson(Map<String, dynamic> json) {
    DateTime enterDateTime = DateTime.parse(json['enterDateTime']);
    DateTime? exitDateTime;

    if (json['exitDateTime'] != null) {
      exitDateTime = DateTime.parse(json['exitDateTime']);
    }

    return AssetZoneHistory(
      id: json['id'],
      assetId: json['assetId'],
      zoneId: json['zoneId'],
      enterDateTime: enterDateTime,
      exitDateTime: exitDateTime,
    );
  }
}
