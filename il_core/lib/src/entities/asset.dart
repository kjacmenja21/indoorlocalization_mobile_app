class Asset {
  int id;
  String name;

  double x;
  double y;

  DateTime lastSync;
  bool active;

  int floorMapId;

  Asset({
    required this.id,
    required this.name,
    required this.x,
    required this.y,
    required this.lastSync,
    required this.active,
    required this.floorMapId,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      name: json['name'],
      x: json['x'],
      y: json['y'],
      lastSync: DateTime.parse(json['lastSync']),
      active: json['active'],
      floorMapId: json['floorMapId'],
    );
  }
}
