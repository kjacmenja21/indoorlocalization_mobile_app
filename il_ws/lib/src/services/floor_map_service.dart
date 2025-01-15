import 'package:il_core/il_entities.dart';
import 'package:il_ws/src/services/web_service.dart';

abstract class IFloorMapService {
  Future<List<FloorMap>> getAllFloorMaps();
  Future<List<FloorMapZone>> getFloorMapZones(int floorMapId);
}

class FloorMapService extends WebService implements IFloorMapService {
  static List<FloorMap> _cachedFloorMaps = [];
  static DateTime? _floorMapsCacheDate;

  @override
  Future<List<FloorMap>> getAllFloorMaps() async {
    List<FloorMap>? floorMaps = _loadCachedFloorMaps();

    if (floorMaps != null) {
      return floorMaps;
    }

    var response = await httpGet(
      path: '/api/v1/floor-maps/',
      queryParameters: {
        'page': '0',
        'limit': '10000',
      },
    );

    var floorMapsJson = response['page'] as List<dynamic>;

    floorMaps = floorMapsJson.map((e) {
      return FloorMap.fromJson(e);
    }).toList();

    _saveFloorMaps(floorMaps);
    return floorMaps;
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

  void _saveFloorMaps(List<FloorMap> floorMaps) {
    _cachedFloorMaps = [...floorMaps];
    _floorMapsCacheDate = DateTime.now();
  }

  List<FloorMap>? _loadCachedFloorMaps() {
    if (_cachedFloorMaps.isEmpty || _floorMapsCacheDate == null) {
      return null;
    }

    var now = DateTime.now();
    var cacheAge = now.difference(_floorMapsCacheDate!);

    if (cacheAge.inMinutes >= 10) {
      return null;
    }

    return [..._cachedFloorMaps];
  }
}
