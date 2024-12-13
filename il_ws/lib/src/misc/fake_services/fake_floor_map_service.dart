import 'dart:ui';

import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';

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
          size: Size(3000, 2000),
          svgImage: _testSvg,
        ),
        FloorMap(
          id: 2,
          name: 'Floor map 2',
          trackingArea: Rect.fromLTWH(0, 0, 3000, 2000),
          size: Size(3000, 2000),
          svgImage: _testSvg,
        ),
      ];
    });
  }

  @override
  Future<List<FloorMapZone>> getFloorMapZones(int floorMapId) async {
    double x = 1300;
    double y = 180;
    double w = 1500;
    double h = 1200;

    return Future.delayed(Duration(milliseconds: 500), () {
      return [
        FloorMapZone(
          id: 1,
          name: 'Zone 1',
          color: Color.fromARGB(255, 255, 167, 38),
          points: [
            Offset(x, y),
            Offset(x + w, y),
            Offset(x + w, y + h),
            Offset(x, y + h),
          ],
          floorMapId: floorMapId,
        ),
      ];
    });
  }
}
