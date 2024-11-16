import 'package:il_basic_auth/il_basic_auth.dart';
import 'package:il_core/il_core.dart';
import 'package:il_entities/il_entities.dart';

class BasicLoginHandler extends LoginHandler {
  @override
  void handleLogin({
    required LoginToken baseToken,
    required LoginOutcomeListener loginListener,
  }) {
    if (baseToken is BasicLoginToken == false) {
      throw ArgumentError("Must receive BasicLoginToken instance");
    }

    BasicLoginToken token = baseToken as BasicLoginToken;

    if (token.username == "admin" && token.password == "admin") {
      loginListener.onSuccessfulLogin(
        User(
          id: 0,
          username: 'admin',
          firstName: '',
          lastName: '',
          email: '',
          contact: '',
          role: UserRole(id: 0, name: ''),
        ),
      );
    } else {
      loginListener.onFailedLogin("Invalid username or password.");
    }
  }
}
