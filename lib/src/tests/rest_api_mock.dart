import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/foundation.dart';

class RestApiMock<C> extends RestApi {
  C _content;
  RestResponseType _responseType = RestResponseType.unknown;

  RestApiMock({@required C content, @required RestResponseType responseType})
      : _content = content,
        _responseType = responseType;

  @override
  Future<RestResponse> request(
      {RestMethod method,
      String path,
      Map<String, dynamic> requestBody = const {}}) async {
    return RestResponse<C>(
      type: _responseType,
      uri: Uri.http('', path),
      content: _content,
    );
  }
}
