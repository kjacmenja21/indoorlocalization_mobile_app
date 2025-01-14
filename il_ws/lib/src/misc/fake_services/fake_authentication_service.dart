import 'package:il_core/il_entities.dart';
import 'package:il_core/il_exceptions.dart';
import 'package:il_ws/il_ws.dart';

class FakeAuthenticationService implements IAuthenticationService {
  @override
  Future<RegisteredUser> login(String username, String password) async {
    if (username == "bruno" && password == "bruno") {
      return Future.value(
        RegisteredUser(
          user: User(
            id: 1,
            username: 'bruno',
            firstName: 'Bruno',
            lastName: 'Brunić',
            email: 'bbrunic@gmail.com',
            contact: '99 100 2000',
            role: UserRole(id: 1, name: 'Admin'),
          ),
          accessToken: JwtToken(value: 'access-token-bruno'),
          refreshToken: JwtToken(value: 'refresh-token-bruno'),
        ),
      );
    }

    throw WebServiceException("Invalid username or password.");
  }

  @override
  Future<RegisteredUser> renewSession(JwtToken refreshToken) {
    if (refreshToken.value == 'refresh-token-bruno') {
      return login('bruno', 'bruno');
    }
    throw WebServiceException("Error");
  }

  @override
  Future<MqttCredentials> getMqttCredentials() {
    throw UnimplementedError();
  }
}
