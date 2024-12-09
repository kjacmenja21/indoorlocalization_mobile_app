import 'dart:ui';

import 'package:il_core/il_entities.dart';

abstract class IFloorMapService {
  Future<List<FloorMap>> getAllFloorMaps();
  Future<List<FloorMapZone>> getFloorMapZones(int floorMapId);
}

class FakeFloorMapService implements IFloorMapService {
  final _testSvg = '''
  <svg id="air" viewBox="0 0 3000 2000" shape-rendering="geometricPrecision" text-rendering="geometricPrecision">
    <rect id="rect1" width="240" height="1520" x="260" y="240" fill="none" stroke="#000000" stroke-width="4"/>
    <rect id="rect2" width="1140" height="200" x="1400" y="240" fill="none" stroke="#000000" stroke-width="4"/>
    <rect id="rect3" width="1140" height="200" x="1400" y="620" fill="none" stroke="#000000" stroke-width="4"/>
    <rect id="rect4" width="1140" height="200" x="1400" y="1000" fill="none" stroke="#000000" stroke-width="4"/>
  </svg>
  ''';

  @override
  Future<List<FloorMap>> getAllFloorMaps() async {
    return Future.delayed(Duration(milliseconds: 500), () {
      return [
        FloorMap(
          id: 1,
          name: 'Floor map 1',
          trackingArea: Rect.fromLTWH(0, 0, 3000, 2000),
          svgImage: _testSvg,
        ),
        FloorMap(
          id: 2,
          name: 'Floor map 2',
          trackingArea: Rect.fromLTWH(0, 0, 3000, 2000),
          svgImage: _testSvg,
        ),
      ];
    });
  }

  @override
  Future<List<FloorMapZone>> getFloorMapZones(int floorMapId) async {
    return Future.delayed(Duration(milliseconds: 500), () {
      return [];
    });
  }
}
