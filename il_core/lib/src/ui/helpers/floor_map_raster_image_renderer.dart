import 'dart:async';
import 'dart:ui';

import 'package:il_core/il_entities.dart';
import 'package:il_core/il_ui_helpers.dart';

import 'package:flutter/rendering.dart' show paintImage, BoxFit;

class FloorMapRasterImageRenderer implements IFloorMapImageRenderer {
  final FloorMap floorMap;

  Image? _image;

  FloorMapRasterImageRenderer(this.floorMap);

  @override
  void draw(Canvas canvas) {
    if (_image == null) return;

    var size = floorMap.size;

    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, size.width, size.height),
      image: _image!,
      fit: BoxFit.fill,
    );
  }

  @override
  Future<void> load() async {
    var completer = Completer();

    decodeImageFromList(floorMap.image!, (Image result) {
      _image = result;
      completer.complete();
    });

    return completer.future;
  }

  @override
  void dispose() {
    _image?.dispose();
  }
}
