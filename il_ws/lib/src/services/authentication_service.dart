import 'package:il_core/il_core.dart';
import 'package:il_entities/il_entities.dart';
import 'package:il_ws/src/services/web_service.dart';

abstract class IAuthenticationService {
  Future<RegisteredUser> login(String username, String password);
}

class AuthenticationService extends WebService implements IAuthenticationService {
  @override
  Future<RegisteredUser> login(String username, String password) async {
    var response = await httpPost(path: '/api/login', body: {
      'username': username,
      'password': password,
    });

    var user = User.fromJson(response);
    var jwtToken = response['token'];

    return RegisteredUser(
      user: user,
      jwtToken: jwtToken,
    );
  }
}

class FakeAuthenticationService implements IAuthenticationService {
  @override
  Future<RegisteredUser> login(String username, String password) async {
    if (username == "admin" && password == "admin") {
      return Future.value(
        RegisteredUser(
          user: User(
            id: 0,
            username: 'admin',
            firstName: '',
            lastName: '',
            email: '',
            contact: '',
            role: UserRole(id: 0, name: ''),
          ),
          jwtToken: '',
        ),
      );
    }

    throw AppException("Invalid username or password.");
  }
}
