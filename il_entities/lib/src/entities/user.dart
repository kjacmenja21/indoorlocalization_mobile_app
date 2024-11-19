import 'package:il_entities/src/entities/user_role.dart';

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
}
