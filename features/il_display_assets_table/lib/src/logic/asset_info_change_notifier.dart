import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_display_assets_table/src/models/asset_info.dart';

class AssetInfoChangeNotifier extends AssetsChangeNotifier {
  List<AssetInfo> assetData = [];

  AssetInfoChangeNotifier(super.floorMap);

  @override
  void setAssets(List<Asset> assets) {
    assetData = assets.map((e) => AssetInfo.fromAsset(e, floorMap)).toList();
    super.setAssets(assets);
  }

  @override
  bool updateAssetLocation(AssetLocation location) {
    int i = assets.indexWhere((e) => e.id == location.id);
    if (i == -1) {
      return false;
    }

    var asset = assets[i];

    asset.updateLocation(location);
    assetData[i] = AssetInfo.fromAsset(asset, floorMap);

    notifyListeners();
    return true;
  }
}
