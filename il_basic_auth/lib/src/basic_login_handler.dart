import 'package:il_core/il_core.dart';
import 'package:il_core/il_exceptions.dart';
import 'package:il_ws/il_ws.dart';

class BasicLoginToken implements ILoginToken {
  final String username;
  final String password;

  BasicLoginToken(this.username, this.password);
}

class BasicLoginHandler extends ILoginHandler {
  IAuthenticationService authService;

  BasicLoginHandler(this.authService);

  @override
  void handleLogin({
    required ILoginToken baseToken,
    required LoginOutcomeListener loginListener,
  }) async {
    if (baseToken is BasicLoginToken == false) {
      throw ArgumentError("Must receive BasicLoginToken instance");
    }

    BasicLoginToken token = baseToken as BasicLoginToken;

    try {
      var registeredUser = await authService.login(token.username, token.password);

      loginListener.onSuccessfulLogin(registeredUser);
    } catch (a) {
      var e = AppException.from(a);
      loginListener.onFailedLogin(e.message);
    }
  }
}
