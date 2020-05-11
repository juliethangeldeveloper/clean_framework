import 'dart:async';

import 'package:clean_framework/external_dependency.dart';
import 'package:flutter/foundation.dart';

/// This abstract class provides API to standardize the way http
/// request actions such as get | put | delete | post are performed
/// on a typical json based restful webservices. The concrete implementation
/// of this type would implement requirements specific to that particular
/// restful webservices.

enum RestMethod { get, post, put, delete, patch }

abstract class RestApi<T extends RestResponse> extends ExternalDependency {
  Future<T> request({
    @required RestMethod method,
    @required String uri,
    @required Map<String, dynamic> requestData,
  });

  RestResponseType getResponseTypeFromCode(int code) =>
      _responseCodeToRestResponseTypeMap[code] ?? RestResponseType.unknown;
}

class RestResponse<T> {
  final RestResponseType type;
  final T content;
  final String uri;

  RestResponse({
    this.type = RestResponseType.unknown,
    this.content,
    this.uri,
  }) : assert(content != null && uri != null);
}

enum RestResponseType {
  // Success
  success,

  // Errors
  timeOut,
  badRequest,
  notFound,
  conflict,
  internal,
  unauthorized,
  unknown,
}

final _responseCodeToRestResponseTypeMap = {
  200: RestResponseType.success,
  201: RestResponseType.success,
  400: RestResponseType.badRequest,
  401: RestResponseType.unauthorized,
  403: RestResponseType.unauthorized,
  404: RestResponseType.notFound,
  409: RestResponseType.conflict,
  500: RestResponseType.internal,
};
