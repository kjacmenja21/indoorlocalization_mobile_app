import 'package:il_core/il_entities.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ISessionService {
  Future<JwtToken?> loadSession();
  Future<void> saveSession(RegisteredUser registeredUser);
  Future<void> deleteSession();
}

class SessionService implements ISessionService {
  static const String _refreshTokenKey = 'user-refresh-token';

  @override
  Future<JwtToken?> loadSession() async {
    var prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString(_refreshTokenKey);
    if (token == null) {
      return null;
    }

    try {
      return JwtToken.decode(token);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveSession(RegisteredUser registeredUser) async {
    String token = registeredUser.refreshToken.value;

    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  @override
  Future<void> deleteSession() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refreshTokenKey);
  }
}
