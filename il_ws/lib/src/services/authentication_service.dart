import 'package:il_core/il_entities.dart';
import 'package:il_core/il_exceptions.dart';
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
          jwtToken: 'bruno-jwt-token',
        ),
      );
    }

    throw WebServiceException("Invalid username or password.");
  }

  @override
  Future<RegisteredUser> renewSession(String token) {
    if (token == 'bruno-jwt-token') {
      return login('bruno', 'bruno');
    }
    throw WebServiceException("Error");
  }
}
