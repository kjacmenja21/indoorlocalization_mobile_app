import 'dart:ui';

class FloorMapZone {
  int id;
  String name;
  Color color;
  List<Offset> points;

  int floorMapId;

  FloorMapZone({
    required this.id,
    required this.name,
    required this.color,
    required this.points,
    required this.floorMapId,
  });

  Offset get labelPoint => points.first;

  factory FloorMapZone.fromJson(Map<String, dynamic> json) {
    var pointsJson = json['points'] as List<dynamic>;

    pointsJson.sort((a, b) {
      int n1 = a['ordinalNumber'];
      int n2 = b['ordinalNumber'];

      return n1.compareTo(n2);
    });
    var points = pointsJson.map((e) => Offset(e['x'], e['y'])).toList();

    var color = json['color'] as int;

    return FloorMapZone(
      id: json['id'],
      name: json['name'],
      color: Color(color).withAlpha(255),
      points: points,
      floorMapId: json['floorMapId'],
    );
  }
}
