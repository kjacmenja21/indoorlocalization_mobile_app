import 'dart:ui';

import 'package:il_core/il_entities.dart';

abstract class IFloorMapService {
  Future<List<FloorMap>> getAllFloorMaps();
  Future<List<FloorMapZone>> getFloorMapZones(int floorMapId);
}

class FakeFloorMapService implements IFloorMapService {
  @override
  Future<List<FloorMap>> getAllFloorMaps() async {
    return [
      FloorMap(
        id: 1,
        name: 'Floor map 1',
        trackingArea: Rect.fromLTWH(0, 0, 300, 200),
        svgImage: '',
      ),
      FloorMap(
        id: 2,
        name: 'Floor map 2',
        trackingArea: Rect.fromLTWH(0, 0, 300, 200),
        svgImage: '',
      ),
    ];
  }

  @override
  Future<List<FloorMapZone>> getFloorMapZones(int floorMapId) async {
    return [];
  }
}
