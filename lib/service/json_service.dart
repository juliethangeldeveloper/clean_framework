import 'dart:async';
import 'dart:convert';

import 'package:clean_framework/locator.dart';
import 'package:flutter/foundation.dart';

import 'rest_api.dart';
import 'service.dart';

abstract class JsonRequestModel extends RequestModel {
  Map<String, dynamic> toJson();
}

abstract class JsonResponseModel extends ResponseModel {
  //TODO Find a way to make the factory implementation required
  //JsonResponseModel.fromJson(Map<String, dynamic> json);
}

abstract class JsonService<
    R extends JsonRequestModel,
    S extends JsonResponseModel,
    H extends ResponseErrorHandler> extends Service<R, S, H> {
  final RestApi _restApi;
  final String _path;
  final RestMethod _method;
  final H _handler;

  JsonService({
    @required String path,
    @required RestMethod method,
    @required H handler,
    @required RestApi restApi,
  })  : assert(restApi != null &&
            path != null &&
            path.isNotEmpty &&
            handler != null &&
            method != null),
        _path = path,
        _restApi = restApi,
        _method = method,
        _handler = handler;

  @override
  Future<S> request({R requestModel}) async {
    //TODO Move out of framework:
    //UserActivity.updateMostRecentActivity();

    //TODO Add check for connectivity here

    Map<String, dynamic> requestJson;
    if (requestModel != null) {
      requestJson = _getValidJson(requestModel);
      if (requestJson == null) {
        _handler.onInvalidRequest();
        return null;
      }
    } else
      requestJson = <String, dynamic>{};

    FilteredRequest request = _getFilteredRequest(requestJson);
    if (!request.isValid) {
      _handler.onMissingPathData();
      return null;
    }

    final RestResponse response = await _restApi.request(
        method: _method, uri: request.path, requestData: request.data);

    if (response.type == RestResponseType.timeOut) {
      _handler.onNoConnectivity();
      return null;
    } else if (response.type == RestResponseType.unauthorized) {
      _handler.onInvalidSession();
      return null;
    } else if (response.type != RestResponseType.success) {
      if (!onError(response, _handler)) {
        _handler.onServerError();
        return null;
      }
    }

    try {
      final Map<String, dynamic> jsonResponse =
          json.decode(response.content) ?? <String, dynamic>{};
      return parseJson(jsonResponse);
    } on Error catch (e) {
      Locator()
          .logger
          .debug('JsonService request parse error', e, e.stackTrace);
      _handler.onUnexpectedContent();
    }

    return null;
  }

  S parseJson(Map<String, dynamic> map);

  /// This method is meant to be overridden when the service includes a custom
  /// error handler. By default, that functionality is not required and a
  /// normal server error is generated.
  @override
  bool onError(RestResponse response, H handler) {
    return false;
  }

  Map<String, dynamic> _getValidJson(R requestModel) {
    try {
      final Map<String, dynamic> json = requestModel.toJson();
      if (_jsonContainsNull(json)) return null;
      return json;
    } on Error {
      return null;
    }
  }

  bool _jsonContainsNull(Map<String, dynamic> json) {
    bool containsNull = false;
    List values = json.values.toList(growable: false);
    for (int i = 0; i < values.length; i++) {
      if (values[i] is Map)
        containsNull = _jsonContainsNull(values[i]);
      else if (values[i] == null) containsNull = true;
      if (containsNull) break;
    }
    return containsNull;
  }

  List<String> _getVariablesFromPath() {
    final exp = RegExp(r'{(\w+)}');
    Iterable<RegExpMatch> matches = exp.allMatches(_path);
    final foundVariables =
        matches.map((m) => m.group(1)).toList(growable: false);
    return foundVariables;
  }

  FilteredRequest _getFilteredRequest(Map<String, dynamic> requestJson) {
    final variablesInPath = _getVariablesFromPath();
    if (variablesInPath.length > 0 && requestJson.length == 0) {
      return FilteredRequest(isValid: false);
    } else if (requestJson.length == 0)
      return FilteredRequest(path: _path, data: requestJson);

    final Map<String, dynamic> filteredJson = Map.from(requestJson);
    String replacedPath = _path;

    bool missingVariable = false;
    variablesInPath.forEach((variable) {
      if (requestJson.containsKey(variable)) {
        replacedPath =
            replacedPath.replaceAll('{$variable}', requestJson[variable]);
        filteredJson.remove(variable);
      } else {
        missingVariable = true;
      }
    });
    if (missingVariable) return FilteredRequest(isValid: false);

    return FilteredRequest(path: replacedPath, data: filteredJson);
  }
}

class FilteredRequest {
  final bool isValid;
  final String path;
  final Map<String, dynamic> data;

  FilteredRequest({
    this.isValid = true,
    this.path = '',
    this.data = const <String, dynamic>{},
  });
}
