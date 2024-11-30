import 'package:il_entities/il_entities.dart';

class RegisteredUser {
  final User user;
  final String jwtToken;

  RegisteredUser({
    required this.user,
    required this.jwtToken,
  });
}
