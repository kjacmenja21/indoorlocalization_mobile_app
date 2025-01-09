import 'package:flutter/widgets.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/src/logic/display_assets/assets_change_notifier.dart';

abstract class IAssetDisplayHandler {
  @protected
  AssetsChangeNotifier? assetsChangeNotifier;

  void activate(FloorMap floorMap);
  void deactivate();

  void showAssets(List<Asset> assets);

  Widget buildSelectWidget({required VoidCallback onTap});
  Widget buildWidget(BuildContext context);

  void dispose();
}
