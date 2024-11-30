import 'package:flutter/material.dart';
import 'package:il_app/logic/services/session_service.dart';
import 'package:il_app/models/message.dart';
import 'package:il_basic_auth/il_basic_auth.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_exceptions.dart';
import 'package:il_ws/il_ws.dart';

class EntryPageViewModel extends ChangeNotifier {
  static const String serviceName = '_http._tcp.local';
  static const String targetName = 'foi-air-adaptiq-il._http._tcp.local';

  Message? message;

  final VoidCallback navigateToLoginPage;
  final VoidCallback navigateToHomePage;

  EntryPageViewModel({
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

    try {
      //await _discoverLocalBackend();
    } on AppException catch (e) {
      message = Message.error(e.message);
      notifyListeners();
      return;
    }

    _loadSession();
  }

  void _loadSession() async {
    var sessionService = SessionService();
    String? jwtToken = await sessionService.loadSession();

    if (jwtToken == null) {
      navigateToLoginPage();
      return;
    }

    var autoLoginHandler = AutoLoginHandler(FakeAuthenticationService());
    var token = AutoLoginToken(jwtToken);

    autoLoginHandler.handleLogin(
      baseToken: token,
      loginListener: LoginOutcomeListener(
        onSuccessfulLogin: (registeredUser) {
          AuthenticationContext.currentUser = registeredUser;

          var sessionService = SessionService();
          sessionService.saveSession(registeredUser);

          navigateToHomePage();
        },
        onFailedLogin: (reason) {
          navigateToLoginPage();
        },
      ),
    );
  }

  Future<void> _discoverLocalBackend() async {
    var backendDiscovery = BackendDiscovery();
    var address = await backendDiscovery.discoverBackendAddress(serviceName, targetName);

    BackendContext.httpServerAddress = '$address:80';
  }
}
