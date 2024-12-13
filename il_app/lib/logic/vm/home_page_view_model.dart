import 'package:il_app/logic/vm/view_model.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';

class HomePageViewModel extends ViewModel {
  late final IFloorMapService _floorMapService;

  List<FloorMap> _floorMaps = [];
  bool _isLoading = true;

  HomePageViewModel({
    required IFloorMapService floorMapService,
  }) {
    _floorMapService = floorMapService;
    _loadFloorMaps();
  }

  List<FloorMap> get floorMaps => _floorMaps;
  bool get isLoading => _isLoading;

  Future<void> _loadFloorMaps() async {
    _floorMaps = await _floorMapService.getAllFloorMaps();
    _isLoading = false;
    notifyListeners();
  }
}
