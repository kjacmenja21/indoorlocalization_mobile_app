import 'package:flutter/material.dart';
import 'package:il_app/logic/services/session_service.dart';
import 'package:il_app/models/message.dart';
import 'package:il_basic_auth/il_basic_auth.dart';
import 'package:il_core/il_core.dart';
import 'package:il_ws/il_ws.dart';

class LoginViewModel extends ChangeNotifier {
  final tcUsername = TextEditingController();
  final tcPassword = TextEditingController();

  final loginHandler = BasicLoginHandler(FakeAuthenticationService());

  bool showPassword = false;
  Message? message;

  final VoidCallback navigateToHomePage;

  LoginViewModel({required this.navigateToHomePage});

  void login() {
    var username = tcUsername.text.trim();
    var password = tcPassword.text.trim();

    if (username.isEmpty) {
      message = Message.error('Please enter your username.');
      notifyListeners();
      return;
    }

    if (password.isEmpty) {
      message = Message.error('Please enter your password.');
      notifyListeners();
      return;
    }

    var token = BasicLoginToken(username, password);

    loginHandler.handleLogin(
      baseToken: token,
      loginListener: LoginOutcomeListener(
        onSuccessfulLogin: (registeredUser) {
          AuthenticationContext.currentUser = registeredUser;

          var sessionService = SessionService();
          sessionService.saveSession(registeredUser);

          navigateToHomePage();
        },
        onFailedLogin: (reason) {
          message = Message.error(reason);
          notifyListeners();
        },
      ),
    );
  }

  void togglePasswordVisibility() {
    showPassword = !showPassword;
    notifyListeners();
  }

  void clearMessage() {
    message = null;
    notifyListeners();
  }

  @override
  void dispose() {
    tcUsername.dispose();
    tcPassword.dispose();
    super.dispose();
  }
}
