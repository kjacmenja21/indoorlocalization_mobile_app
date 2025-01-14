import 'dart:async';
import 'dart:math' as math;

import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';

class FakeAssetLocationTracker implements IAssetLocationTracker {
  Timer? _timer;
  StreamController<AssetLocation>? _streamController;

  @override
  Future<void> connect() async {
    if (_timer != null) {
      close();
    }

    _streamController = StreamController();

    _timer = Timer.periodic(
      Duration(milliseconds: 1000),
      (timer) {
        var random = math.Random();

        int id = random.nextInt(3) + 1;
        double x = random.nextInt(3000).toDouble();
        double y = random.nextInt(2000).toDouble();

        var location = AssetLocation(id: id, x: x, y: y, floorMapId: 1);
        _streamController!.sink.add(location);
      },
    );

    return Future.delayed(Duration(milliseconds: 500));
  }

  @override
  void close() {
    _streamController?.close();
    _streamController = null;

    _timer?.cancel();
    _timer = null;
  }

  @override
  Stream<AssetLocation> get stream => _streamController!.stream;
}
