import 'package:il_core/il_entities.dart';

abstract class IAssetService {
  Future<List<Asset>> getAllAssets();
  Future<List<Asset>> getAssetsByFloorMap(int floorMapId);
}
