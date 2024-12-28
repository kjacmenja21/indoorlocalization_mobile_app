import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_widgets.dart';
import 'package:il_display_assets_map/src/widgets/assets_painter.dart';
import 'package:il_display_assets_map/src/widgets/floor_map_painter.dart';

class AssetsWidget extends StatelessWidget {
  final FloorMap floorMap;
  final List<Asset> assets;

  const AssetsWidget({
    super.key,
    required this.floorMap,
    required this.assets,
  });

  @override
  Widget build(BuildContext context) {
    return FloorMapWidget(
      floorMap: floorMap,
      backgroundBuilder: (svg) {
        return CustomPaint(
          willChange: false,
          isComplex: true,
          size: floorMap.size,
          painter: FloorMapPainter(
            floorMap: floorMap,
            svg: svg,
          ),
        );
      },
      foregroundBuilder: (size, transform) {
        return CustomPaint(
          willChange: true,
          size: size,
          painter: AssetsPainter(
            transform: transform,
            floorMap: floorMap,
            assets: assets,
          ),
        );
      },
    );
  }
}
