import 'dart:ui';

import 'package:il_core/il_entities.dart';

class FloorMap {
  int id;
  String name;

  Rect trackingArea;
  Size size;

  String svgImage;

  List<FloorMapZone>? zones;

  FloorMap({
    required this.id,
    required this.name,
    required this.trackingArea,
    required this.size,
    required this.svgImage,
    this.zones,
  });

  factory FloorMap.fromJson(Map<String, dynamic> json) {
    return FloorMap(
      id: json['id'],
      name: json['name'],
      trackingArea: Rect.fromLTWH(
        json['tx'],
        json['ty'],
        json['tw'],
        json['th'],
      ),
      size: Size(
        json['width'],
        json['height'],
      ),
      svgImage: json['svg'],
    );
  }
}
