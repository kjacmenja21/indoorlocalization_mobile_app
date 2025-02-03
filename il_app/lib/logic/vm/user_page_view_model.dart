import 'package:flutter/material.dart';
import 'package:il_app/logic/services/session_service.dart';
import 'package:il_app/logic/vm/view_model.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';

class UserPageViewModel extends ViewModel {
  late final User user;

  final ISessionService sessionService;
  final IFloorMapService floorMapService;
  final VoidCallback navigateToLoginPage;
  final void Function(Object e) showExceptionPage;

  UserPageViewModel({
    required this.sessionService,
    required this.floorMapService,
    required this.navigateToLoginPage,
    required this.showExceptionPage,
  }) {
    user = AuthenticationContext.currentUser!.user;
  }

  Future<void> logout() async {
    AuthenticationContext.currentUser = null;
    await sessionService.deleteSession();
    navigateToLoginPage();
  }

  Future<void> clearCache() async {
    try {
      await floorMapService.clearCachedFloorMaps();
    } catch (e) {
      showExceptionPage(e);
    }
  }
}
