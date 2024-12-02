import 'package:il_core/il_entities.dart';

class User {
  final int id;
  final String username;

  final String firstName;
  final String lastName;

  final String email;
  final String contact;

  final UserRole role;

  User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contact,
    required this.role,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      contact: json['contact'],
      role: UserRole.fromJson(json['role']),
    );
  }
}
