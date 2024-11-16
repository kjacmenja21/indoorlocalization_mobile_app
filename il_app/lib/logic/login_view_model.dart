import 'package:flutter/material.dart';
import 'package:il_app/models/message.dart';
import 'package:il_basic_auth/il_basic_auth.dart';
import 'package:il_core/il_core.dart';

class LoginViewModel extends ChangeNotifier {
  final tcUsername = TextEditingController();
  final tcPassword = TextEditingController();

  final loginHandler = BasicLoginHandler();

  bool showPassword = false;
  Message? message;

  void login() {
    var username = tcUsername.text;
    var password = tcPassword.text;

    var token = BasicLoginToken(username, password);

    loginHandler.handleLogin(
      baseToken: token,
      loginListener: LoginOutcomeListener(
        onSuccessfulLogin: (user) {
          message = Message.success('Success login ${user.username}');
          notifyListeners();
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
