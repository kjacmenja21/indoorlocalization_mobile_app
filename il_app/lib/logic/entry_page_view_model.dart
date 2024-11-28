import 'package:flutter/material.dart';
import 'package:il_app/models/message.dart';
import 'package:il_core/il_core.dart';
import 'package:il_ws/il_ws.dart';

class EntryPageViewModel extends ChangeNotifier {
  static const String serviceName = '_http._tcp.local';
  static const String targetName = 'foi-air-adaptiq-il._http._tcp.local';

  Message? message;

  EntryPageViewModel() {
    runTasks();
  }

  Future<void> runTasks() async {
    if (message != null) {
      message = null;
      notifyListeners();
    }

    try {
      await _discoverLocalBackend();
    } on AppException catch (e) {
      message = Message.error(e.message);
      notifyListeners();
      return;
    }
  }

  Future<void> _discoverLocalBackend() async {
    var backendDiscovery = BackendDiscovery();
    var address = await backendDiscovery.discoverBackendAddress(serviceName, targetName);

    BackendContext.httpServerAddress = '$address:80';
  }
}
