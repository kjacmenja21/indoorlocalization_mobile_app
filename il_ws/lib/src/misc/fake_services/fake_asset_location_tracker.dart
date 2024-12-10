import 'dart:async';
import 'dart:math' as math;

import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';

class FakeAssetLocationTracker implements IAssetLocationTracker {
  Timer? _timer;

  @override
  Future<void> connect() async {
    return Future.delayed(Duration(milliseconds: 500));
  }

  @override
  void addListener(AssetLocationCallback onData) {
    _timer = Timer.periodic(
      Duration(milliseconds: 1000),
      (timer) {
        var random = math.Random();

        int id = random.nextInt(3) + 1;
        double x = random.nextInt(3000).toDouble();
        double y = random.nextInt(2000).toDouble();

        var location = AssetLocation(id: id, x: x, y: y);

        onData(location);
      },
    );
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
  }
}
