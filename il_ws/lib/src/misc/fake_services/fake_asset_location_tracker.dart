import 'dart:async';
import 'dart:math' as math;

import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';

class FakeAssetLocationTracker implements IAssetLocationTracker {
  Timer? _timer;
  final List<AssetLocationCallback> _listeners = [];

  @override
  Future<void> connect() async {
    if (_timer != null) {
      await close();
    }

    _timer = Timer.periodic(
      Duration(milliseconds: 1000),
      (timer) {
        var random = math.Random();

        int id = random.nextInt(3) + 1;
        double x = random.nextInt(3000).toDouble();
        double y = random.nextInt(2000).toDouble();

        var location = AssetLocation(id: id, x: x, y: y, floorMapId: 0);

        for (var listener in _listeners) {
          listener.call(location);
        }
      },
    );

    return Future.delayed(Duration(milliseconds: 500));
  }

  @override
  void addListener(AssetLocationCallback onData) {
    _listeners.add(onData);
  }

  @override
  Future<void> close() async {
    _listeners.clear();
    _timer?.cancel();
    _timer = null;
  }
}
