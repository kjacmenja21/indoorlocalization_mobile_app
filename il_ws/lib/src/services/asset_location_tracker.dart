import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_exceptions.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef AssetLocationCallback = void Function(AssetLocation location);

abstract class IAssetLocationTracker {
  Future<void> connect();
  void close();

  Stream<AssetLocation> get stream;
}

class AssetLocationTracker implements IAssetLocationTracker {
  MqttServerClient? _client;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _mqttStreamSub;

  bool _connected = false;
  StreamController<AssetLocation>? _streamController;

  static const String _assetLocationTopic = '/test/topic';

  @override
  Future<void> connect() async {
    if (_connected) {
      return;
    }

    var server = BackendContext.mqttServerAddress;
    var port = BackendContext.mqttServerPort;

    var username = BackendContext.mqttUsername;
    var password = BackendContext.mqttPassword;
    var clientId = _generateClientId();

    _client = MqttServerClient.withPort(server, clientId, port);

    await _client!.connect(username, password);

    if (_client!.connectionStatus?.state != MqttConnectionState.connected) {
      close();
      throw AppException('Mqtt connection failed!');
    }

    _client!.subscribe(_assetLocationTopic, MqttQos.atLeastOnce);
    _mqttStreamSub = _client!.updates!.listen(_onMqttMessage);

    _streamController = StreamController();
  }

  @override
  void close() {
    _connected = false;

    _streamController?.close();
    _streamController = null;

    _mqttStreamSub?.cancel();
    _mqttStreamSub = null;

    _client?.disconnect();
    _client = null;
  }

  @override
  Stream<AssetLocation> get stream => _streamController!.stream;

  String _generateClientId() {
    var random = math.Random();
    var bytes = List.generate(32, (index) => random.nextInt(255));

    return 'mobile-app-${base64Encode(bytes)}';
  }

  void _onMqttMessage(List<MqttReceivedMessage<MqttMessage>> messages) {
    for (var message in messages) {
      var payload = message.payload;

      if (payload is MqttPublishMessage) {
        _handleMessage(message.topic, payload.payload.message.buffer.asUint8List());
      }
    }
  }

  void _handleMessage(String topic, Uint8List data) {
    try {
      if (topic != _assetLocationTopic) return;

      var text = String.fromCharCodes(data).trim();
      var json = jsonDecode(text);

      var location = _parseLocation(json);
      _streamController!.sink.add(location);
    } catch (a) {
      var e = AppException.from(a);
      log(e.message);
    }
  }

  AssetLocation _parseLocation(dynamic json) {
    return AssetLocation(
      id: (json['id'] as num).toInt(),
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      floorMapId: (json['floorMap'] as num).toInt(),
    );
  }
}
