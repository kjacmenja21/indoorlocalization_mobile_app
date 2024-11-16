import 'package:il_basic_auth/il_basic_auth.dart';
import 'package:il_core/il_core.dart';
import 'package:il_ws/il_ws.dart';

class BasicLoginHandler extends LoginHandler {
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
      var authService = AuthenticationService();
      var user = await authService.login(token.username, token.password);

      loginListener.onSuccessfulLogin(user);
    } on AppException catch (e) {
      loginListener.onFailedLogin(e.message);
    }
  }
}
