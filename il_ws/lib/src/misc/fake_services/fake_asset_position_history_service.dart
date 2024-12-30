import 'package:il_core/il_entities.dart';
import 'package:il_ws/src/services/asset_position_history_service.dart';

class FakeAssetPositionHistoryService implements IAssetPositionHistoryService {
  @override
  Future<List<AssetPositionHistory>> getPositionHistory({required int assetId, required int floorMapId, required DateTime startDate, required DateTime endDate}) {
    return Future.delayed(Duration(milliseconds: 500), () {
      return [];
    });
  }

  @override
  Future<List<AssetZoneHistory>> getZoneHistory({
    required int assetId,
    required int floorMapId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return Future.delayed(Duration(milliseconds: 500), () {
      return [
        AssetZoneHistory(
          id: 1,
          assetId: assetId,
          zoneId: 1,
          enterDateTime: DateTime.parse('2024-12-10 08:00'),
          exitDateTime: DateTime.parse('2024-12-10 09:00'),
        ),
        AssetZoneHistory(
          id: 1,
          assetId: assetId,
          zoneId: 1,
          enterDateTime: DateTime.parse('2024-12-10 10:00'),
          exitDateTime: DateTime.parse('2024-12-10 11:30'),
        ),
        AssetZoneHistory(
          id: 1,
          assetId: assetId,
          zoneId: 2,
          enterDateTime: DateTime.parse('2024-12-10 11:40'),
          exitDateTime: DateTime.parse('2024-12-10 14:00'),
        ),
        AssetZoneHistory(
          id: 1,
          assetId: assetId,
          zoneId: 1,
          enterDateTime: DateTime.parse('2024-12-10 14:10'),
          exitDateTime: DateTime.parse('2024-12-10 14:20'),
        ),
      ];
    });
  }
}
