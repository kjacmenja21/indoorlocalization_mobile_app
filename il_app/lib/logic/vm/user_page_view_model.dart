import 'package:flutter/material.dart';
import 'package:il_app/logic/services/session_service.dart';
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';

class UserPageViewModel extends ChangeNotifier {
  late final User user;

  final VoidCallback navigateToLoginPage;

  UserPageViewModel({
    required this.navigateToLoginPage,
  }) {
    user = AuthenticationContext.currentUser!.user;
  }

  void logout() async {
    AuthenticationContext.currentUser = null;

    var sessionService = SessionService();
    await sessionService.deleteSession();

    navigateToLoginPage();
  }
}
