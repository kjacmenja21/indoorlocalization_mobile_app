import 'package:il_core/il_entities.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ISessionService {
  Future<String?> loadSession();
  Future<void> saveSession(RegisteredUser registeredUser);
  Future<void> deleteSession();
}

class SessionService implements ISessionService {
  static const String _userTokenKey = 'userJwtToken';

  @override
  Future<String?> loadSession() async {
    var prefs = await SharedPreferences.getInstance();

    String? jwtToken = prefs.getString(_userTokenKey);
    return jwtToken;
  }

  @override
  Future<void> saveSession(RegisteredUser registeredUser) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTokenKey, registeredUser.jwtToken);
  }

  @override
  Future<void> deleteSession() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userTokenKey);
  }
}
