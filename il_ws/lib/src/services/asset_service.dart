import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';
import 'package:il_ws/src/services/web_service.dart';

abstract class IAssetService {
  Future<List<Asset>> getAllAssets();
  Future<List<Asset>> getAssetsByFloorMap(int floorMapId);
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

    var floorMapService = FloorMapService();
    var floorMaps = await floorMapService.getAllFloorMaps();

    var assets = response['page'] as List<dynamic>;

    return assets.map((e) {
      var asset = Asset.fromJson(e);
      asset.floorMap = floorMaps.firstWhere((e) => e.id == asset.floorMapId);
      return asset;
    }).toList();
  }

  @override
  Future<List<Asset>> getAssetsByFloorMap(int floorMapId) async {
    var assets = await getAllAssets();
    return assets.where((e) => e.floorMapId == floorMapId).toList();
  }
}
