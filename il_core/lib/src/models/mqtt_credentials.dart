class MqttCredentials {
  final String serverAddress;
  final int serverPort;

  final String username;
  final String password;

  MqttCredentials({
    required this.serverAddress,
    required this.serverPort,
    required this.username,
    required this.password,
  });

  factory MqttCredentials.fromJson(Map<String, dynamic> json) {
    return MqttCredentials(
      serverAddress: json['mqttServerAddress'],
      serverPort: json['mqttServerPort'],
      username: json['mqttUsername'],
      password: json['mqttPassword'],
    );
  }
}
