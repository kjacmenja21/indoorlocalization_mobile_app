import 'package:il_core/il_entities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _userTokenKey = 'userJwtToken';

  Future<String?> loadSession() async {
    var prefs = await SharedPreferences.getInstance();

    String? jwtToken = prefs.getString(_userTokenKey);
    return jwtToken;
  }

  Future<void> saveSession(RegisteredUser registeredUser) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTokenKey, registeredUser.jwtToken);
  }
}
