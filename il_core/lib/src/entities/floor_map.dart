import 'dart:ui';

class FloorMap {
  int id;
  String name;

  Rect trackingArea;
  String svgImage;

  FloorMap({
    required this.id,
    required this.name,
    required this.trackingArea,
    required this.svgImage,
  });

  factory FloorMap.fromJson(Map<String, dynamic> json) {
    return FloorMap(
      id: json['id'],
      name: json['name'],
      trackingArea: Rect.fromLTWH(
        json['offsetX'],
        json['offsetY'],
        json['width'],
        json['height'],
      ),
      svgImage: json['svg'],
    );
  }
}
