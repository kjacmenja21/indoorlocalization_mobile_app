import 'package:il_core/il_entities.dart';

abstract class IAssetPositionHistoryService {
  Future<List<AssetPositionHistory>> getPositionHistory({
    required int assetId,
    required int floorMapId,
    required DateTime startDate,
    required DateTime endDate,
  });
}
