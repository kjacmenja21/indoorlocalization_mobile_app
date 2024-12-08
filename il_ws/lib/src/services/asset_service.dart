import 'package:il_core/il_entities.dart';

abstract class IAssetService {
  Future<List<Asset>> getAllAssets();
  Future<List<Asset>> getAssetsByFloorMap(int floorMapId);
}

class FakeAssetService implements IAssetService {
  @override
  Future<List<Asset>> getAllAssets() async {
    return [
      Asset(id: 1, name: 'Asset 1', x: 10, y: 10, lastSync: DateTime.now(), active: true, floorMapId: 1),
      Asset(id: 2, name: 'Asset 2', x: 10, y: 10, lastSync: DateTime.now(), active: true, floorMapId: 1),
      Asset(id: 3, name: 'Asset 3', x: 10, y: 10, lastSync: DateTime.now(), active: true, floorMapId: 1),
    ];
  }

  @override
  Future<List<Asset>> getAssetsByFloorMap(int floorMapId) async {
    return [
      Asset(id: 1, name: 'Asset 1', x: 10, y: 10, lastSync: DateTime.now(), active: true, floorMapId: floorMapId),
      Asset(id: 2, name: 'Asset 2', x: 10, y: 10, lastSync: DateTime.now(), active: true, floorMapId: floorMapId),
      Asset(id: 3, name: 'Asset 3', x: 10, y: 10, lastSync: DateTime.now(), active: true, floorMapId: floorMapId),
    ];
  }
}
