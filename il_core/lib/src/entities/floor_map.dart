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

    List<FloorMapZone>? zones;

    if (json.containsKey('zones')) {
      var zonesJson = json['zones'] as List<dynamic>;
      zones = zonesJson.map((e) => FloorMapZone.fromJson(e)).toList();
    }

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
      zones: zones,
    );
  }

  Map<String, dynamic> toJson() {
    var json = {
      'id': id,
      'name': name,
      'image': base64Encode(image!),
      'image_type': imageType,
      'tx': trackingArea.left,
      'ty': trackingArea.top,
      'tw': trackingArea.width,
      'th': trackingArea.height,
      'width': size.width,
      'height': size.height,
    };

    if (zones != null) {
      json['zones'] = zones!.map((e) => e.toJson()).toList();
    }

    return json;
  }
}
