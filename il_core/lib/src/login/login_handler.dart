import 'package:il_entities/il_entities.dart';

abstract class LoginToken {}

class LoginOutcomeListener {
  final void Function(User user) onSuccessfulLogin;
  final void Function(String reason) onFailedLogin;

  LoginOutcomeListener({
    required this.onSuccessfulLogin,
    required this.onFailedLogin,
  });
}

abstract class LoginHandler {
  void handleLogin({
    required LoginToken baseToken,
    required LoginOutcomeListener loginListener,
  });
}
