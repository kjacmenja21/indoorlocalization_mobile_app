import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef AssetLocationCallback = void Function(AssetLocation location);

abstract class IAssetLocationTracker {
  Future<void> connect();
  Future<void> close();

  Stream<AssetLocation> get stream;
}

class AssetLocationTracker implements IAssetLocationTracker {
  MqttServerClient? _client;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _streamSub;

  StreamController<AssetLocation>? _streamController;

  @override
  Future<void> connect() async {
    if (_client != null) {
      return;
    }

    var server = BackendContext.mqttServerAddress;
    var port = BackendContext.mqttServerPort;

    var username = BackendContext.mqttUsername;
    var password = BackendContext.mqttPassword;

    _client = MqttServerClient.withPort(server, 'flutter_app', port);
    await _client!.connect(username, password);

    _client!.subscribe('/test/topic', MqttQos.atLeastOnce);
    _streamSub = _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> data) {
      for (var e in data) {
        var payload = e.payload;

        if (payload is MqttPublishMessage) {
          _handleMessage(e.topic, payload.payload.message.buffer.asUint8List());
        }
      }
    });

    _streamController = StreamController();
  }

  @override
  Future<void> close() async {
    _streamController?.close();
    _streamController = null;

    _streamSub?.cancel();
    _client?.disconnect();

    _streamSub = null;
    _client = null;
  }

  @override
  Stream<AssetLocation> get stream => _streamController!.stream;

  void _handleMessage(String topic, Uint8List data) {
    try {
      if (topic != '/test/topic') return;

      var text = String.fromCharCodes(data).trim();
      var json = jsonDecode(text);

      var location = _parseLocation(json);

      _streamController!.sink.add(location);
    } catch (_) {}
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
