import 'dart:async';

import 'package:clean_framework/service/rest_api.dart';

class RestApiSuccessMock extends RestApi {
  final Map<String, dynamic> content;

  RestApiSuccessMock(this.content);

  @override
  Future<RestResponse> request(
      {RestMethod method, String uri, Map<String, dynamic> requestData}) async {
    return RestResponse<Map<String, dynamic>>(
      type: RestResponseType.success,
      uri: uri,
      content: content,
    );
  }
}

class RestApiFailureMock extends RestApi {
  final RestResponseType errorType;

  RestApiFailureMock(this.errorType);

  @override
  Future<RestResponse> request(
      {RestMethod method, String uri, Map<String, dynamic> requestData}) async {
    return RestResponse<Map<String, dynamic>>(
      type: errorType,
      uri: uri,
      content: <String, dynamic>{},
    );
  }
}
