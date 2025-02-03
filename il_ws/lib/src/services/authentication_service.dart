import 'package:il_core/il_entities.dart';
import 'package:il_ws/src/services/web_service.dart';

abstract class IAuthenticationService {
  Future<RegisteredUser> login(String username, String password);
  Future<RegisteredUser> renewSession(JwtToken refreshToken);

  Future<MqttCredentials> getMqttCredentials();
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
    return renewUserSession(refreshToken);
  }

  @override
  Future<MqttCredentials> getMqttCredentials() async {
    var response = await httpGet(path: '/api/v1/mqtt/');
    return MqttCredentials.fromJson(response);
  }
}
