import 'package:il_core/il_core.dart';
import 'package:il_core/il_exceptions.dart';
import 'package:il_ws/il_ws.dart';

class AutoLoginToken implements ILoginToken {
  final String jwtToken;

  AutoLoginToken(this.jwtToken);
}

class AutoLoginHandler extends ILoginHandler {
  IAuthenticationService authService;

  AutoLoginHandler(this.authService);

  @override
  void handleLogin({
    required ILoginToken baseToken,
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
