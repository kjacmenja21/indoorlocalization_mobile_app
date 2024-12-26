import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_fake_services.dart';
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
        'limit': '100',
      },
    );

    var floorMaps = response['page'] as List<dynamic>;

    return floorMaps.map((e) {
      e['svg'] = FakeFloorMapService.testSvg;
      return FloorMap.fromJson(e);
    }).toList();
  }

  @override
  Future<List<FloorMapZone>> getFloorMapZones(int floorMapId) async {
    return FakeFloorMapService().getFloorMapZones(floorMapId);
  }
}
