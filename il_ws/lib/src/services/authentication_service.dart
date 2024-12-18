import 'package:il_core/il_entities.dart';
import 'package:il_ws/src/services/web_service.dart';

abstract class IAuthenticationService {
  Future<RegisteredUser> login(String username, String password);
  Future<RegisteredUser> renewSession(JwtToken refreshToken);
}

class AuthenticationService extends WebService implements IAuthenticationService {
  @override
  Future<RegisteredUser> login(String username, String password) async {
    var response = await httpPost(
      path: '/api/v1/auth/login',
      body: {
        'username': username,
        'password': password,
      },
      contentType: 'application/x-www-form-urlencoded',
    );

    var user = User.fromJson(response['data']);
    var accessToken = JwtToken.decode(response['access_token']);
    var refreshToken = JwtToken.decode(response['refresh_token']);

    return RegisteredUser(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<RegisteredUser> renewSession(JwtToken refreshToken) async {
    var cookie = 'refresh-token=${refreshToken.value}';

    var response = await httpPost(
      path: '/api/v1/auth/autologin',
      headers: {'Cookie': cookie},
    );

    var user = User.fromJson(response['data']);
    var accessToken = JwtToken.decode(response['access_token']);
    var newRefreshToken = JwtToken.decode(response['refresh_token']);

    return RegisteredUser(
      user: user,
      accessToken: accessToken,
      refreshToken: newRefreshToken,
    );
  }
}
