import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:il_core/il_core.dart';
import 'package:il_core/il_exceptions.dart';

typedef JsonObject = Map<String, dynamic>;

class WebService {
  Future<JsonObject> httpGet({
    required String path,
    Map<String, dynamic>? queryParameters,
    int successfulStatusCode = 200,
  }) async {
    String base = BackendContext.httpServerAddress;
    Uri uri = Uri.http(base, path, queryParameters);

    var currentUser = AuthenticationContext.currentUser;

    var headers = <String, String>{};
    if (currentUser != null) {
      headers['Authorization'] = 'Bearer ${currentUser.jwtToken}';
    }

    var response = await http.get(uri, headers: headers);
    var data = response.json;

    if (response.statusCode != successfulStatusCode) {
      String msg = data['msg'] ?? 'Unknown error!';
      throw WebServiceException(msg);
    }

    return data;
  }

  Future<JsonObject> httpPost({
    required String path,
    required JsonObject body,
    int successfulStatusCode = 201,
  }) async {
    String base = BackendContext.httpServerAddress;
    Uri uri = Uri.http(base, path);

    var currentUser = AuthenticationContext.currentUser;

    var headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (currentUser != null) {
      headers['Authorization'] = 'Bearer ${currentUser.jwtToken}';
    }

    var response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
      encoding: utf8,
    );

    var data = response.json;

    if (response.statusCode != successfulStatusCode) {
      String msg = data['msg'] ?? 'Unknown error!';
      throw WebServiceException(msg);
    }

    return data;
  }
}

extension on http.Response {
  JsonObject get json {
    if (body.isEmpty) return {};
    var jsonText = const Utf8Decoder().convert(bodyBytes);
    return jsonDecode(jsonText);
  }
}
