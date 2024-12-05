import 'package:flutter/widgets.dart';
import 'package:il_core/il_entities.dart';

class AssetDisplayChangeNotifier extends ChangeNotifier {
  List<Asset> assets = [];

  void show(List<Asset> assets) {
    this.assets = assets;
    notifyListeners();
  }
}

abstract class IAssetDisplayHandler {
  @protected
  late AssetDisplayChangeNotifier changeNotifier;

  String getDisplayName();

  Widget buildWidget(BuildContext context);
  void showAssets(List<Asset> assets);

  void dispose();
}
