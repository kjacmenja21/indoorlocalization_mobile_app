import 'dart:convert';

class JwtToken {
  final String value;

  late int _expirationTime;

  JwtToken({required this.value}) {
    _expirationTime = _getExpirationTime(value);
  }

  factory JwtToken.decode(String token) {
    return JwtToken(value: token);
  }

  bool isExpired() {
    DateTime now = DateTime.now();
    int seconds = now.millisecondsSinceEpoch ~/ 1000;

    return seconds >= _expirationTime;
  }

  int _getExpirationTime(String value) {
    var parts = value.split('.');
    var json = utf8.decode(base64Decode(_base64Padded(parts[1])));
    var payload = jsonDecode(json);

    return payload['exp'];
  }

  String _base64Padded(String value) {
    var lenght = value.length;

    switch (lenght % 4) {
      case 2:
        return value.padRight(lenght + 2, '=');
      case 3:
        return value.padRight(lenght + 1, '=');
      default:
        return value;
    }
  }
}
