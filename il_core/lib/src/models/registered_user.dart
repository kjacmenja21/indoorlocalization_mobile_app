import 'package:il_core/il_entities.dart';

class RegisteredUser {
  final User user;
  final JwtToken accessToken;
  final JwtToken refreshToken;

  RegisteredUser({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });
}
