import 'package:flutter/material.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';

class AssetsPageViewModel extends ChangeNotifier {
  final tcSearch = TextEditingController();

  late final IAssetService _assetService;

  List<Asset> _allAssets = [];
  List<Asset> _currentAssets = [];
  bool _isLoading = true;

  AssetsPageViewModel({required IAssetService assetService}) {
    _assetService = assetService;

    tcSearch.addListener(() {
      _onSearchTextChanged(tcSearch.value.text);
    });

    _loadAllAssets();
  }

  List<Asset> get assets => _currentAssets;
  bool get isLoading => _isLoading;

  void _onSearchTextChanged(String text) {
    text = text.trim().toLowerCase();

    if (text.isEmpty) {
      _currentAssets = _allAssets;
      notifyListeners();
      return;
    }

    _currentAssets = _allAssets.where((asset) {
      String name = asset.name.toLowerCase();

      if (name.contains(text)) {
        return true;
      }

      return false;
    }).toList();
    notifyListeners();
  }

  Future<void> _loadAllAssets() async {
    _allAssets = await _assetService.getAllAssets();
    _currentAssets = _allAssets;
    _isLoading = false;

    notifyListeners();
  }

  @override
  void dispose() {
    tcSearch.dispose();
    super.dispose();
  }
}
