import 'dart:ui';

import 'package:il_core/il_entities.dart';
import 'package:il_core/il_helpers.dart';

class Asset {
  int id;
  String name;

  double x;
  double y;

  DateTime lastSync;
  bool active;

  int floorMapId;
  FloorMap? floorMap;

  Asset({
    required this.id,
    required this.name,
    required this.x,
    required this.y,
    required this.lastSync,
    required this.active,
    required this.floorMapId,
    this.floorMap,
  });

  /// Returns the zone in which the asset is currently located.
  /// If the asset is not in any zone, returns null.
  FloorMapZone? getCurrentZone([FloorMap? floorMap]) {
    floorMap ??= this.floorMap;
    if (floorMap == null) return null;

    var zones = floorMap.zones;
    if (zones == null) return null;

    var geometryHelper = GeometryHelper();
    var assetPosition = Offset(x, y);

    for (var zone in zones) {
      if (geometryHelper.polygonContainsPoint(polygon: zone.points, point: assetPosition)) {
        return zone;
      }
    }

    return null;
  }

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      name: json['name'],
      x: json['x'],
      y: json['y'],
      lastSync: DateTime.parse(json['last_sync']),
      active: json['active'],
      floorMapId: json['floormap_id'],
    );
  }
}
