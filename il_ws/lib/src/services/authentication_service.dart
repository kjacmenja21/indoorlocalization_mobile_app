import 'package:il_core/il_core.dart';
import 'package:il_entities/il_entities.dart';

class AuthenticationService {
  Future<User> login(String username, String password) async {
    if (username == "admin" && password == "admin") {
      return Future.value(
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
    }

    throw AppException("Invalid username or password.");
  }
}
