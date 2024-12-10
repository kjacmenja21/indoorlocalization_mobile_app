import 'package:il_core/il_entities.dart';
import 'package:il_ws/src/services/web_service.dart';

abstract class IAuthenticationService {
  Future<RegisteredUser> login(String username, String password);
  Future<RegisteredUser> renewSession(String token);
}

class AuthenticationService extends WebService implements IAuthenticationService {
  @override
  Future<RegisteredUser> login(String username, String password) async {
    var response = await httpPost(path: '/api/login', body: {
      'username': username,
      'password': password,
    });

    var user = User.fromJson(response['user']);
    var jwtToken = response['token'] as String;

    return RegisteredUser(
      user: user,
      jwtToken: jwtToken,
    );
  }

  @override
  Future<RegisteredUser> renewSession(String token) async {
    var response = await httpPost(path: '/api/autologin', body: {
      'token': token,
    });

    var user = User.fromJson(response['user']);
    var jwtToken = response['token'] as String;

    return RegisteredUser(
      user: user,
      jwtToken: jwtToken,
    );
  }
}
