import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';

class FakeAssetService implements IAssetService {
  @override
  Future<List<Asset>> getAllAssets() async {
    return Future.delayed(Duration(milliseconds: 500), () {
      return [
        Asset(id: 1, name: 'Asset 1', x: 100, y: 100, lastSync: DateTime.now(), active: true, floorMapId: 1),
        Asset(id: 2, name: 'Asset 2', x: 500, y: 500, lastSync: DateTime.now(), active: true, floorMapId: 1),
        Asset(id: 3, name: 'Asset 3', x: 1000, y: 1000, lastSync: DateTime.now(), active: true, floorMapId: 1),
      ];
    });
  }

  @override
  Future<List<Asset>> getAssetsByFloorMap(int floorMapId) async {
    return Future.delayed(Duration(milliseconds: 500), () {
      return [
        Asset(id: 1, name: 'Asset 1', x: 100, y: 100, lastSync: DateTime.now(), active: true, floorMapId: floorMapId),
        Asset(id: 2, name: 'Asset 2', x: 500, y: 500, lastSync: DateTime.now(), active: true, floorMapId: floorMapId),
        Asset(id: 3, name: 'Asset 3', x: 1000, y: 1000, lastSync: DateTime.now(), active: true, floorMapId: floorMapId),
      ];
    });
  }
}