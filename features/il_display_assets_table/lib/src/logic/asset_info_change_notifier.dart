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
  void updatedAssetLocation(int index, Asset asset) {
    assetData[index] = AssetInfo.fromAsset(asset, floorMap);
    super.updatedAssetLocation(index, asset);
  }
}
