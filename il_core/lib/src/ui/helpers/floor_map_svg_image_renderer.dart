import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_ui_helpers.dart';

class FloorMapSvgImageRenderer implements IFloorMapImageRenderer {
  final FloorMap floorMap;

  PictureInfo? _svg;

  FloorMapSvgImageRenderer(this.floorMap);

  @override
  void draw(Canvas canvas) {
    if (_svg == null) return;

    var paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.color = Color.fromARGB(255, 255, 255, 255);

    var size = floorMap.size;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawPicture(_svg!.picture);
  }

  @override
  Future<void> load() async {
    if (floorMap.image == null) {
      throw ArgumentError('Floor map image is null');
    }

    _svg = await vg.loadPicture(SvgBytesLoader(floorMap.image!), null);
  }

  @override
  void dispose() {
    _svg?.picture.dispose();
  }
}
