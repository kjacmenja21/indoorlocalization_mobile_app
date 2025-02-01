import 'package:flutter/material.dart';
import 'package:il_app/logic/services/session_service.dart';
import 'package:il_app/logic/vm/view_model.dart';
import 'package:il_app/models/message.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_ws/il_ws.dart';

class EntryPageViewModel extends ViewModel {
  Message? message;

  final ISessionService sessionService;
  final IAuthenticationService authService;
  final VoidCallback navigateToLoginPage;
  final VoidCallback navigateToHomePage;

  EntryPageViewModel({
    required this.sessionService,
    required this.authService,
    required this.navigateToLoginPage,
    required this.navigateToHomePage,
  }) {
    runTasks();
  }

  Future<void> runTasks() async {
    if (message != null) {
      message = null;
      notifyListeners();
    }

    _loadSession();
  }

  void _loadSession() async {
    JwtToken? refreshToken = await sessionService.loadSession();

    if (refreshToken == null) {
      navigateToLoginPage();
      return;
    }

    try {
      var registeredUser = await authService.renewSession(refreshToken);

      AuthenticationContext.currentUser = registeredUser;
      sessionService.saveSession(registeredUser);
      navigateToHomePage();
    } catch (_) {
      sessionService.deleteSession();
      navigateToLoginPage();
    }
  }
}
