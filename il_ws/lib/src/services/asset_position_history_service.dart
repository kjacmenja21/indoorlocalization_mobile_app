import 'package:il_core/il_entities.dart';
import 'package:il_ws/src/services/web_service.dart';

abstract class IAssetPositionHistoryService {
  Future<List<AssetPositionHistory>> getPositionHistory({
    required int assetId,
    required int floorMapId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<AssetZoneHistory>> getZoneHistory({
    required int assetId,
    required int floorMapId,
    required DateTime startDate,
    required DateTime endDate,
  });
}

class AssetPositionHistoryService extends WebService implements IAssetPositionHistoryService {
  @override
  Future<List<AssetPositionHistory>> getPositionHistory({
    required int assetId,
    required int floorMapId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    var response = await httpGet(
      path: '/api/v1/asset-position/',
      queryParameters: {
        'id': assetId.toString(),
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
    );

    var positionHistory = response as List<dynamic>;

    return positionHistory.map((e) {
      return AssetPositionHistory.fromJson(e);
    }).toList();
  }

  @override
  Future<List<AssetZoneHistory>> getZoneHistory({
    required int assetId,
    required int floorMapId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    var response = await httpGet(
      path: '/api/v1/asset-zone-history/',
      queryParameters: {
        'assetId': assetId.toString(),
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
    );

    var zoneHistory = response as List<dynamic>;

    return zoneHistory.map((e) {
      return AssetZoneHistory.fromJson(e);
    }).toList();
  }
}
