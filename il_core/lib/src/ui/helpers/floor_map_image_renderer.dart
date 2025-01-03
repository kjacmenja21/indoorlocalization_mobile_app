import 'dart:ui';

import 'package:il_core/il_entities.dart';
import 'package:il_core/src/ui/helpers/floor_map_svg_image_renderer.dart';

abstract class IFloorMapImageRenderer {
  Future<void> load();

  void draw(Canvas canvas);
  void dispose();

  factory IFloorMapImageRenderer.fromFloorMap(FloorMap floorMap) {
    return FloorMapSvgImageRenderer(floorMap);
  }
}
