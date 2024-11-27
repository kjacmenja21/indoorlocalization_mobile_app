import 'package:il_basic_auth/il_basic_auth.dart';
import 'package:il_core/il_core.dart';
import 'package:il_ws/il_ws.dart';

class BasicLoginHandler extends LoginHandler {
  IAuthenticationService authService;

  BasicLoginHandler(this.authService);

  @override
  void handleLogin({
    required LoginToken baseToken,
    required LoginOutcomeListener loginListener,
  }) async {
    if (baseToken is BasicLoginToken == false) {
      throw ArgumentError("Must receive BasicLoginToken instance");
    }

    BasicLoginToken token = baseToken as BasicLoginToken;

    try {
      var registeredUser = await authService.login(token.username, token.password);

      loginListener.onSuccessfulLogin(registeredUser);
    } on AppException catch (e) {
      loginListener.onFailedLogin(e.message);
    }
  }
}
