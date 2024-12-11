import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';

class AssetsPageViewModel extends ChangeNotifier {
  final tcSearch = TextEditingController();

  late final IAssetService _assetService;

  List<Asset> _assets = [];
  bool _isLoading = true;

  AssetsPageViewModel({required IAssetService assetService}) {
    _assetService = assetService;
    _loadAssets();
  }

  List<Asset> get assets => _assets;
  bool get isLoading => _isLoading;

  Future<void> _loadAssets() async {
    _assets = await _assetService.getAllAssets();
    _isLoading = false;

    notifyListeners();
  }

  @override
  void dispose() {
    tcSearch.dispose();
    super.dispose();
  }
}
