import 'package:flutter/material.dart';
import 'package:il_app/logic/services/session_service.dart';
import 'package:il_app/logic/vm/view_model.dart';
import 'package:il_app/models/message.dart';
import 'package:il_basic_auth/il_basic_auth.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';

class EntryPageViewModel extends ViewModel {
  Message? message;

  final ISessionService sessionService;
  final ILoginHandler autoLoginHandler;
  final VoidCallback navigateToLoginPage;
  final VoidCallback navigateToHomePage;

  EntryPageViewModel({
    required this.sessionService,
    required this.autoLoginHandler,
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

    var token = AutoLoginToken(refreshToken);

    autoLoginHandler.handleLogin(
      baseToken: token,
      loginListener: LoginOutcomeListener(
        onSuccessfulLogin: (registeredUser) {
          AuthenticationContext.currentUser = registeredUser;

          sessionService.saveSession(registeredUser);

          navigateToHomePage();
        },
        onFailedLogin: (reason) {
          sessionService.deleteSession();
          navigateToLoginPage();
        },
      ),
    );
  }
}
