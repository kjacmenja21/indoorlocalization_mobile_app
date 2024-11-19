import 'package:il_core/il_core.dart';

class BasicLoginToken implements LoginToken {
  final String username;
  final String password;

  BasicLoginToken(this.username, this.password);
}
