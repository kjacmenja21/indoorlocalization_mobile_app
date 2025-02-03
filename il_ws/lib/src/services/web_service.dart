import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:il_core/il_core.dart';
import 'package:il_core/il_entities.dart';
import 'package:il_core/il_exceptions.dart';

typedef JsonObject = dynamic;

class WebService {
  Future<JsonObject> httpGet({
    required String path,
    Map<String, dynamic>? queryParameters,
    int successfulStatusCode = 200,
    Map<String, String>? headers,
  }) async {
    String base = BackendContext.httpServerAddress;
    Uri uri = Uri.https(base, path, queryParameters);

    var currentUser = AuthenticationContext.currentUser;

    headers ??= {};

    if (currentUser != null) {
      await _refreshUserSession();
      headers['Authorization'] = 'Bearer ${currentUser.accessToken.value}';
    }

    var response = await http.get(uri, headers: headers);
    var data = response.json;

    if (response.statusCode != successfulStatusCode) {
      String msg = _getMessage(data);
      throw WebServiceException(msg);
    }

    return data;
  }

  Future<JsonObject> httpPost({
    required String path,
    Object? body,
    int successfulStatusCode = 200,
    String contentType = 'application/json',
    Map<String, String>? headers,
  }) async {
    String base = BackendContext.httpServerAddress;
    Uri uri = Uri.https(base, path);

    var currentUser = AuthenticationContext.currentUser;

    headers ??= {};
    headers['Content-Type'] = contentType;

    if (currentUser != null) {
      await _refreshUserSession();
      headers['Authorization'] = 'Bearer ${currentUser.accessToken.value}';
    }

    if (contentType == 'application/json') {
      body = jsonEncode(body);
    }

    var response = await http.post(
      uri,
      headers: headers,
      body: body,
      encoding: utf8,
    );

    var data = response.json;

    if (response.statusCode != successfulStatusCode) {
      String msg = _getMessage(data);
      throw WebServiceException(msg);
    }

    return data;
  }

  Future<RegisteredUser> renewUserSession(JwtToken refreshToken) async {
    String path = '/api/v1/auth/autologin';
    String base = BackendContext.httpServerAddress;
    Uri uri = Uri.https(base, path);

    String cookie = 'refresh-token=${refreshToken.value}';

    var headers = {
      'Cookie': cookie,
    };

    var response = await http.post(
      uri,
      headers: headers,
      encoding: utf8,
    );

    var data = response.json;

    if (response.statusCode != 200) {
      String msg = _getMessage(data);
      throw WebServiceException(msg);
    }

    var user = User.fromJson(data['data']);
    var accessToken = JwtToken.decode(data['access_token']);
    var newRefreshToken = JwtToken.decode(data['refresh_token']);

    return RegisteredUser(
      user: user,
      accessToken: accessToken,
      refreshToken: newRefreshToken,
    );
  }

  Future<void> _refreshUserSession() async {
    var currentUser = AuthenticationContext.currentUser;
    if (currentUser == null) return;

    if (currentUser.accessToken.isExpired()) {
      var user = await renewUserSession(currentUser.refreshToken);
      AuthenticationContext.currentUser = user;
    }
  }

  String _getMessage(JsonObject data) {
    var detail = data['detail'];

    if (detail is String) {
      return detail;
    }

    return 'Unknown error!';
  }
}

extension on http.Response {
  JsonObject get json {
    if (body.isEmpty) return {};
    var jsonText = const Utf8Decoder().convert(bodyBytes);
    return jsonDecode(jsonText);
  }
}
