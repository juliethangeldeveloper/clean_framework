import 'dart:convert';

import 'package:clean_framework/clean_framework.dart';

abstract class JsonResponseModel extends ServiceResponseModel {
  JsonResponseModel();
  // I have to find yet a way to force this constructor on implementation
  // JsonResponseModel.fromJson(Map<String, dynamic> json);
}

abstract class JsonRequestModel extends ServiceRequestModel {
  Map<String, dynamic> toJson();
}

abstract class JsonService<
    R extends JsonRequestModel,
    S extends JsonResponseModel,
    H extends JsonServiceResponseHandler<S>> implements Service<R, S> {
  RestApi _restApi;
  String _path;
  RestMethod _method;
  H _handler;

  final String path;

  JsonService({H handler, RestMethod method, this.path, RestApi restApi})
      : assert(handler != null),
        assert(method != null),
        assert(path != null && path.isNotEmpty),
        assert(restApi != null),
        _handler = handler,
        _path = path,
        _method = method,
        _restApi = restApi;

  @override
  Future<void> request({R requestModel}) async {
    if (await Locator().connectivity.getConnectivityStatus() ==
        ConnectivityStatus.offline) {
      _handler.onNoConnectivity();
      return;
    }

    Map<String, dynamic> requestJson;
    if (requestModel != null) {
      requestJson = requestModel.toJson();
      if (!isRequestModelJsonValid(requestJson)) {
        _handler.onInvalidRequest(requestJson);
        return;
      }
    }

    final variablesInPath = _getVariablesFromPath();
    if (variablesInPath.length > 0) {
      if (requestModel == null) {
        // If a service has a variable in the path, request data is required
        _handler.onInvalidRequest(null);
        return;
      }
      requestJson =
          _filterRequestDataAndUpdatePath(variablesInPath, requestJson);
      if (_getVariablesFromPath(check: true).isNotEmpty) {
        // Some variables where not substituted by request fields
        _handler.onInvalidRequest(requestJson);
        return;
      }
    }

    final response = await _restApi.request(
        method: _method, path: _path, requestBody: requestJson);

    if (response.type == RestResponseType.timeOut) {
      _handler.onNoConnectivity();
      return;
    } else if (response.type != RestResponseType.success) {
      if (!onError(response, _handler)) {
        _handler.onError(response.type, response.content);
        return;
      }
    }

    S model;

    try {
      final Map<String, dynamic> jsonResponse =
          json.decode(response.content) ?? <String, dynamic>{};
      model = parseResponse(jsonResponse);
    } on Error catch (e) {
      Locator().logger.debug(
          'JsonService response parse error', e.toString(), e.stackTrace);
      _handler.onInvalidResponse(response.content);
      return;
    } on Exception catch (e) {
      Locator()
          .logger
          .debug('JsonService response parse exception', e.toString());
      _handler.onInvalidResponse(response.content);
      return;
    }

    _handler.onSuccess(model);
  }

  List<String> _getVariablesFromPath({bool check = false}) {
    RegExp exp = RegExp(r'{(\w+)}');
    Iterable<RegExpMatch> matches = exp.allMatches(check ? _path : path);
    final foundVariables =
        matches.map((m) => m.group(1)).toList(growable: false);
    return foundVariables;
  }

  Map<String, dynamic> _filterRequestDataAndUpdatePath(
    List<String> variables,
    Map<String, dynamic> requestData,
  ) {
    Map<String, dynamic> filteredRequestData = Map.from(requestData);
    variables.forEach((variable) {
      if (requestData.containsKey(variable)) {
        _path =
            path.replaceAll('{$variable}', requestData[variable].toString());
        filteredRequestData.remove(variable);
      }
    });

    return filteredRequestData;
  }

  bool isRequestModelJsonValid(Map<String, dynamic> json) {
    try {
      if (json == null || json.isEmpty) {
        return false;
      }
      if (_jsonContainsNull(json)) return false;
    } catch (e) {
      return false;
    }
    return true;
  }

  bool _jsonContainsNull(Map<String, dynamic> json) {
    bool containsNull = false;
    List values = json.values.toList();
    for (int i = 0; i < values.length; i++) {
      if (values[i] is Map)
        containsNull = _jsonContainsNull(values[i]);
      else if (values[i] == null) containsNull = true;
      if (containsNull) break;
    }
    return containsNull;
  }

  S parseResponse(Map<String, dynamic> jsonResponse);

  bool onError(RestResponse response, JsonServiceResponseHandler<S> handler) {
    return false;
  }
}

abstract class JsonServiceResponseHandler<S extends JsonResponseModel>
    extends ServiceResponseHandler<S> {
  void onMissingPathData(Map<String, dynamic> requestJson);
  void onInvalidRequest(Map<String, dynamic> requestJson);
  void onInvalidResponse(String response);
  void onError(RestResponseType responseType, String response);
}
