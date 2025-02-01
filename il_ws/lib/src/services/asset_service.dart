import 'package:il_core/il_entities.dart';
import 'package:il_ws/src/services/web_service.dart';

abstract class IAssetService {
  Future<List<Asset>> getAllAssets();
  Future<List<Asset>> getAssetsByFloorMap(int floorMapId);

  void assignFloorMaps(List<Asset> assets, List<FloorMap> floorMaps);
}

class AssetService extends WebService implements IAssetService {
  @override
  Future<List<Asset>> getAllAssets() async {
    var response = await httpGet(
      path: '/api/v1/assets/',
      queryParameters: {
        'page': '0',
        'limit': '10000',
      },
    );

    var assets = response['page'] as List<dynamic>;

    return assets.map((e) {
      return Asset.fromJson(e);
    }).toList();
  }

  @override
  Future<List<Asset>> getAssetsByFloorMap(int floorMapId) async {
    var assets = await getAllAssets();
    return assets.where((e) => e.floorMapId == floorMapId).toList();
  }

  @override
  void assignFloorMaps(List<Asset> assets, List<FloorMap> floorMaps) {
    for (var asset in assets) {
      var floorMap = floorMaps.firstWhere((e) => e.id == asset.floorMapId);
      asset.floorMap = floorMap;
    }
  }
}
