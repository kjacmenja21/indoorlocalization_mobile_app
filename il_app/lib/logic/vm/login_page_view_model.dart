import 'package:flutter/material.dart';
import 'package:il_app/logic/services/session_service.dart';
import 'package:il_app/logic/vm/view_model.dart';
import 'package:il_app/models/message.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_exceptions.dart';
import 'package:il_ws/il_ws.dart';

class LoginPageViewModel extends ViewModel {
  final tcUsername = TextEditingController();
  final tcPassword = TextEditingController();

  final ISessionService sessionService;
  final IAuthenticationService authService;
  final VoidCallback navigateToHomePage;

  bool _showPassword = false;
  bool _isLoading = false;
  Message? _message;

  LoginPageViewModel({
    required this.sessionService,
    required this.authService,
    required this.navigateToHomePage,
  });

  Future<void> login() async {
    var username = tcUsername.text.trim();
    var password = tcPassword.text.trim();

    if (username.isEmpty) {
      _message = Message.error('Please enter your username.');
      notifyListeners();
      return;
    }

    if (password.isEmpty) {
      _message = Message.error('Please enter your password.');
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      var registeredUser = await authService.login(username, password);

      AuthenticationContext.currentUser = registeredUser;
      sessionService.saveSession(registeredUser);
      navigateToHomePage();
    } catch (a) {
      var e = AppException.from(a);

      _message = Message.error(e.message);
      _isLoading = false;
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  void clearMessage() {
    _message = null;
    notifyListeners();
  }

  bool get showPassword => _showPassword;
  bool get isLoading => _isLoading;
  Message? get message => _message;

  @override
  void dispose() {
    tcUsername.dispose();
    tcPassword.dispose();
    super.dispose();
  }
}
