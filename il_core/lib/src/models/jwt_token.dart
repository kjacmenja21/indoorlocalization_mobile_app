class JwtToken {
  final String value;

  JwtToken({required this.value});

  factory JwtToken.decode(String token) {
    return JwtToken(value: token);
  }
}
