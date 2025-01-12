import 'package:il_core/il_entities.dart';

class AssetHistoryData {
  Asset asset;
  List<AssetPositionHistory> positionHistory = [];

  AssetHistoryData(this.asset);

  void removeOldPositionHistory() {
    if (positionHistory.length >= 2) {
      positionHistory.removeRange(0, positionHistory.length - 1);
    }
  }
}
