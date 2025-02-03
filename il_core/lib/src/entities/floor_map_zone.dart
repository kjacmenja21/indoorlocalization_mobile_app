import 'dart:ui';

class FloorMapZone {
  int id;
  String name;

  Color color;
  int colorValue;

  List<Offset> points;

  int floorMapId;

  FloorMapZone({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.points,
    required this.floorMapId,
  }) : color = Color(colorValue).withAlpha(255);

  Offset get labelPoint => points.first;

  factory FloorMapZone.fromJson(Map<String, dynamic> json) {
    var pointsJson = json['points'] as List<dynamic>;

    pointsJson.sort((a, b) {
      int n1 = a['ordinalNumber'];
      int n2 = b['ordinalNumber'];

      return n1.compareTo(n2);
    });
    var points = pointsJson.map((e) => Offset(e['x'], e['y'])).toList();

    return FloorMapZone(
      id: json['id'],
      name: json['name'],
      colorValue: json['color'],
      points: points,
      floorMapId: json['floorMapId'],
    );
  }

  Map<String, dynamic> toJson() {
    var points = List.generate(this.points.length, (index) {
      var point = this.points[index];
      return {
        'ordinalNumber': index,
        'x': point.dx,
        'y': point.dy,
      };
    });

    return {
      'id': id,
      'name': name,
      'color': colorValue,
      'points': points,
      'floorMapId': floorMapId,
    };
  }
}
