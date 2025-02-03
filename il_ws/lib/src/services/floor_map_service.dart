import 'dart:convert';
import 'dart:io';

import 'package:il_core/il_entities.dart';
import 'package:il_ws/src/services/web_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class IFloorMapService {
  Future<List<FloorMap>> getAllFloorMaps();
  Future<List<FloorMapZone>> getFloorMapZones(int floorMapId);
}

class FloorMapService extends WebService implements IFloorMapService {
  @override
  Future<List<FloorMap>> getAllFloorMaps() async {
    List<FloorMap>? floorMaps = await _loadCachedFloorMaps();

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
    floorMaps = floorMapsJson.map((e) => FloorMap.fromJson(e)).toList();

    floorMaps.sort((a, b) => a.name.compareTo(b.name));

    await _saveFloorMaps(floorMaps);
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

    var zonesJson = response as List<dynamic>;
    var zones = zonesJson.map((e) => FloorMapZone.fromJson(e)).toList();

    zones.sort((a, b) => a.name.compareTo(b.name));
    return zones;
  }

  Future<void> _saveFloorMaps(List<FloorMap> floorMaps) async {
    var data = {
      'datetime': DateTime.now().toIso8601String(),
      'floor_maps': floorMaps.map((e) => e.toJson()).toList(),
    };

    var json = jsonEncode(data);
    var path = await _getCacheFilePath();
    var file = File(path);

    await file.writeAsString(json);
  }

  Future<List<FloorMap>?> _loadCachedFloorMaps() async {
    var path = await _getCacheFilePath();
    var file = File(path);

    var exists = await file.exists();
    if (!exists) return null;

    try {
      var json = await file.readAsString();
      var data = jsonDecode(json);

      var dateTime = DateTime.parse(data['datetime']);

      var now = DateTime.now();
      var cacheAge = now.difference(dateTime);

      if (cacheAge.inHours >= 2) {
        return null;
      }

      var floorMaps = data['floor_maps'] as List<dynamic>;
      return floorMaps.map((e) => FloorMap.fromJson(e)).toList();
    } catch (_) {
      return null;
    }
  }

  Future<String> _getCacheFilePath() async {
    var cacheDirectory = await getApplicationCacheDirectory();
    return join(cacheDirectory.path, 'floor_maps.json');
  }
}
