import 'dart:async';
import 'dart:io';

import 'package:clean_framework/service/rest_api.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class SimpleRestApi extends RestApi {
  final baseUrl;
  final bool _trustSelfSigned = true;

  HttpClient _httpClient;
  IOClient _ioClient;

  SimpleRestApi({this.baseUrl = 'http://127.0.0.1:8080/service/'}) {
    _httpClient = new HttpClient()
      //@TODO should we remove this? Not sure if its safe for release
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => _trustSelfSigned);
    _ioClient = new IOClient(_httpClient);
  }

  @override
  Future<RestResponse> request(
      {RestMethod method, String uri, Map<String, dynamic> requestData}) async {
    assert(method != null && uri != null && uri.isNotEmpty);

    Response response;
    uri = baseUrl + uri;

    try {
      switch (method) {
        case RestMethod.get:
          response = await _ioClient.get(uri);
          break;
        case RestMethod.post:
          response = await _ioClient.post(uri, body: requestData);
          break;
        case RestMethod.put:
          response = await _ioClient.put(uri, body: requestData);
          break;
        case RestMethod.delete:
          response = await _ioClient.delete(uri);
          break;
        case RestMethod.patch:
          response = await _ioClient.patch(uri, body: requestData);
          break;
      }

      return RestResponse<String>(
        type: RestResponseType.success,
        uri: uri,
        content: response.body,
      );
    } on ClientException {
      return RestResponse<String>(
        type: getResponseTypeFromCode(response.statusCode),
        uri: uri,
        content: response.body,
      );
    } catch (e) {
      return RestResponse<String>(
        type: RestResponseType.unknown,
        uri: uri,
        content: '',
      );
    }
  }
}
