import 'dart:async';

import 'package:il_core/il_entities.dart';

typedef AssetLocationCallback = void Function(AssetLocation location);

abstract class IAssetLocationTracker {
  Future<void> connect();
  Future<void> close();

  void addListener(AssetLocationCallback onData);
}
