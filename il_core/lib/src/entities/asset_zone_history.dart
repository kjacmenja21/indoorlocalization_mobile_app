class AssetZoneHistory {
  int id;
  int assetId;
  int zoneId;

  DateTime enterDateTime;
  DateTime exitDateTime;

  AssetZoneHistory({
    required this.id,
    required this.assetId,
    required this.zoneId,
    required this.enterDateTime,
    required this.exitDateTime,
  });

  Duration get retentionTime {
    return exitDateTime.difference(enterDateTime);
  }
}
