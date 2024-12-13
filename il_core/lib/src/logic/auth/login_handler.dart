import 'package:il_core/il_entities.dart';

abstract class ILoginToken {}

class LoginOutcomeListener {
  final void Function(RegisteredUser registeredUser) onSuccessfulLogin;
  final void Function(String reason) onFailedLogin;

  LoginOutcomeListener({
    required this.onSuccessfulLogin,
    required this.onFailedLogin,
  });
}

abstract class ILoginHandler {
  void handleLogin({
    required ILoginToken baseToken,
    required LoginOutcomeListener loginListener,
  });
}
