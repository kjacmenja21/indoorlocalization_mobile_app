import 'dart:typed_data';
import 'dart:ui';

import 'package:il_core/il_entities.dart';

class FloorMap {
  int id;
  String name;

  Rect trackingArea;
  Size size;

  Uint8List? image;
  String? imageType;

  List<FloorMapZone>? zones;

  FloorMap({
    required this.id,
    required this.name,
    required this.trackingArea,
    required this.size,
    this.image,
    this.imageType,
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
    );
  }
}
