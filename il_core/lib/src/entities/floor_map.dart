import 'dart:convert';
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
    String imageText = json['image'];
    Uint8List image = base64Decode(imageText);

    return FloorMap(
      id: json['id'],
      name: json['name'],
      image: image,
      imageType: json['image_type'],
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
