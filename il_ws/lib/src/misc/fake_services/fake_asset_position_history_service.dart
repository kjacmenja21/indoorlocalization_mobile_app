import 'package:il_core/il_entities.dart';
import 'package:il_ws/src/services/asset_position_history_service.dart';

class FakeAssetPositionHistoryService implements IAssetPositionHistoryService {
  @override
  Future<List<AssetPositionHistory>> getPositionHistory({required int assetId, required int floorMapId, required DateTime startDate, required DateTime endDate}) {
    return Future.delayed(Duration(milliseconds: 500), () {
      return [];
    });
  }
}
