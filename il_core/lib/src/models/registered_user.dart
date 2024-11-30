import 'package:il_core/il_entities.dart';

class RegisteredUser {
  final User user;
  final String jwtToken;

  RegisteredUser({
    required this.user,
    required this.jwtToken,
  });
}
