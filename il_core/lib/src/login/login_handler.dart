import 'package:il_core/il_entities.dart';

abstract class LoginToken {}

class LoginOutcomeListener {
  final void Function(RegisteredUser registeredUser) onSuccessfulLogin;
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
