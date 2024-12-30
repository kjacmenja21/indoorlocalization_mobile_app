import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_fake_services.dart';
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
    return FakeAssetPositionHistoryService().getZoneHistory(
      assetId: assetId,
      floorMapId: floorMapId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
