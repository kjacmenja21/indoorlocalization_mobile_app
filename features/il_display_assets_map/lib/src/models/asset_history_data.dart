import 'package:il_core/il_entities.dart';

class AssetHistoryData {
  Asset asset;
  List<AssetPositionHistory> positionHistory = [];

  AssetHistoryData(this.asset);
}
