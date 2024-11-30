import 'package:il_core/il_core.dart';
import 'package:il_ws/il_ws.dart';

class AutoLoginToken implements LoginToken {
  final String jwtToken;

  AutoLoginToken(this.jwtToken);
}

class AutoLoginHandler extends LoginHandler {
  IAuthenticationService authService;

  AutoLoginHandler(this.authService);

  @override
  void handleLogin({
    required LoginToken baseToken,
    required LoginOutcomeListener loginListener,
  }) async {
    if (baseToken is AutoLoginToken == false) {
      throw ArgumentError("Must receive AutoLoginToken instance");
    }

    AutoLoginToken token = baseToken as AutoLoginToken;

    try {
      var registeredUser = await authService.renewSession(token.jwtToken);

      loginListener.onSuccessfulLogin(registeredUser);
    } on AppException catch (e) {
      loginListener.onFailedLogin(e.message);
    }
  }
}
