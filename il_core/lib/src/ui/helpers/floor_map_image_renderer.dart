import 'dart:ui';

import 'package:il_core/il_entities.dart';
import 'package:il_core/src/ui/helpers/floor_map_raster_image_renderer.dart';
import 'package:il_core/src/ui/helpers/floor_map_svg_image_renderer.dart';

abstract class IFloorMapImageRenderer {
  Future<void> load();

  void draw(Canvas canvas);
  void dispose();

  factory IFloorMapImageRenderer.fromFloorMap(FloorMap floorMap) {
    if (floorMap.image == null) {
      throw ArgumentError('Floor map image is null');
    }

    if (floorMap.imageType == null) {
      throw ArgumentError('Floor map image type is null');
    }

    switch (floorMap.imageType) {
      case 'svg':
        return FloorMapSvgImageRenderer(floorMap);

      case 'png':
      case 'jpg':
        return FloorMapRasterImageRenderer(floorMap);
    }

    throw ArgumentError('Floor map image type ${floorMap.imageType} is not supported');
  }
}
