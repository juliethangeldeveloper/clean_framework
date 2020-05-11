import 'dart:async';

import 'rest_api.dart';

abstract class ResponseModel {}

abstract class RequestModel {}

abstract class Service<R extends RequestModel, T extends ResponseModel,
    U extends ResponseErrorHandler> {
  Future<T> request({R requestModel});

  bool onError(RestResponse response, U handler) {
    return false;
  }
}

abstract class ResponseErrorHandler {
  void onNoConnectivity();

  void onInvalidRequest();

  void onMissingPathData();

  void onUnexpectedContent();

  void onServerError();

  void onInvalidSession();
}
