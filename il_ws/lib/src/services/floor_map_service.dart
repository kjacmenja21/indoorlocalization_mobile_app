import 'package:il_core/il_entities.dart';
import 'package:il_ws/src/services/web_service.dart';

abstract class IFloorMapService {
  Future<List<FloorMap>> getAllFloorMaps();
  Future<List<FloorMapZone>> getFloorMapZones(int floorMapId);
}

class FloorMapService extends WebService implements IFloorMapService {
  @override
  Future<List<FloorMap>> getAllFloorMaps() async {
    var response = await httpGet(
      path: '/api/v1/floor-maps/',
      queryParameters: {
        'page': '0',
        'limit': '10000',
      },
    );

    var floorMaps = response['page'] as List<dynamic>;

    return floorMaps.map((e) {
      return FloorMap.fromJson(e);
    }).toList();
  }

  @override
  Future<List<FloorMapZone>> getFloorMapZones(int floorMapId) async {
    var response = await httpGet(
      path: '/api/v1/zones/',
      queryParameters: {
        'floorMapId': floorMapId.toString(),
      },
    );

    var zones = response as List<dynamic>;

    return zones.map((e) {
      return FloorMapZone.fromJson(e);
    }).toList();
  }
}
