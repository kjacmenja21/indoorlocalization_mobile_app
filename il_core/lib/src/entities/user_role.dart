class UserRole {
  final int id;
  final String name;

  UserRole({
    required this.id,
    required this.name,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      id: json['id'],
      name: json['name'],
    );
  }
}
