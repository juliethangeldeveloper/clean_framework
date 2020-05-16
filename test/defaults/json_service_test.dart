import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:test/test.dart';

import '../test_config.dart';

void main() {
  testConfig();

  test('JsonService asserts', () {
    expect(() => TestJsonService(null, null, null, null),
        throwsA(isA<AssertionError>()));
    expect(
        () =>
            TestJsonService(TestJsonServiceResponseHandler(), null, null, null),
        throwsA(isA<AssertionError>()));
    expect(
        () => TestJsonService(
            TestJsonServiceResponseHandler(), RestMethod.get, null, null),
        throwsA(isA<AssertionError>()));
    expect(
        () => TestJsonService(
            TestJsonServiceResponseHandler(), RestMethod.get, 'test', null),
        throwsA(isA<AssertionError>()));
  });

  test('JsonService GET success', () async {
    final restApiMock = RestApiMock<Map<String, dynamic>>(
      responseType: RestResponseType.success,
      content: <String, dynamic>{'field': 123},
    );
    final handler = TestJsonServiceResponseHandler();
    final service =
        TestJsonService(handler, RestMethod.get, 'test', restApiMock);

    await service.request();
    expect(handler.errorType, isNull);
    expect(handler.model, isNotNull);
    expect(handler.model.field, 123);
    expect(handler.model.optionalField, 'default');
  });

  test('JsonService GET success with request varible', () async {
    final restApiMock = RestApiMock<Map<String, dynamic>>(
      responseType: RestResponseType.success,
      content: <String, dynamic>{'field': 123},
    );
    final handler = TestJsonServiceResponseHandler();
    final service =
        TestJsonService(handler, RestMethod.get, 'test/{id}', restApiMock);

    final requestModel = TestJsonRequestModel(id: '123');

    await service.request(requestModel: requestModel);
    expect(handler.errorType, isNull);
    expect(handler.model, isNotNull);
    expect(handler.model.field, 123);
    expect(handler.model.optionalField, 'default');
  });

  test('JsonService GET server error', () async {
    final restApiMock = RestApiMock<Map<String, dynamic>>(
      responseType: RestResponseType.internalServerError,
      content: <String, dynamic>{},
    );
    final handler = TestJsonServiceResponseHandler();
    final service =
        TestJsonService(handler, RestMethod.get, 'test', restApiMock);

    await service.request();
    expect(handler.model, isNull);
    expect(handler.errorType, RestResponseType.internalServerError);
  });

  test('JsonService GET invalid request', () async {
    final restApiMock = RestApiMock<Map<String, dynamic>>(
      responseType: RestResponseType.success,
      content: <String, dynamic>{'field': 'value'},
    );
    final handler = TestJsonServiceResponseHandler();
    final service =
        TestJsonService(handler, RestMethod.get, 'test/{id}', restApiMock);

    await service.request();
    expect(handler.model, isNull);
    expect(handler.invalidRequestModel, isNull);

    var json = <String, dynamic>{};
    await service.request(requestModel: NullableTestJsonRequestModel(json));

    expect(handler.model, isNull);
    expect(handler.invalidRequestModel, json);

    handler.reset();
    json = {'field': null};
    await service.request(requestModel: NullableTestJsonRequestModel(json));
    expect(handler.model, isNull);
    expect(handler.invalidRequestModel, json);

    handler.reset();
    json = {
      'nested': {'not-null': true, 'field': null}
    };
    await service.request(requestModel: NullableTestJsonRequestModel(json));
    expect(handler.model, isNull);
    expect(handler.invalidRequestModel, json);

    handler.reset();
    json = {'wrong': 'field'};
    await service.request(requestModel: NullableTestJsonRequestModel(json));

    // This should fail because the request path has a variable that is not being set
    // by the request
    expect(handler.model, isNull);
    expect(handler.invalidRequestModel, json);
  });

  test('JsonService GET invalid response', () async {
    var invalidResponse = <String, dynamic>{'field': 'not number'};
    final restApiMock = RestApiMock<Map<String, dynamic>>(
      responseType: RestResponseType.success,
      content: invalidResponse,
    );
    var handler = TestJsonServiceResponseHandler();
    var service = TestJsonService(handler, RestMethod.get, 'test', restApiMock);

    Locator().logger.setLogLevel(LogLevel.nothing);
    await service.request();
    Locator().logger.setLogLevel(defaultLogLevel);

    expect(handler.model, isNull);
    expect(handler.invalidResponse, invalidResponse);
  });

  test('JsonService GET no connectivity', () async {
    // Override of the default connectivity to force offline status
    Locator().connectivity = NoConnectivity();

    final restApiMock = RestApiMock<Map<String, dynamic>>(
      responseType: RestResponseType.success,
      content: <String, dynamic>{'field': 123},
    );
    var handler = TestJsonServiceResponseHandler();
    var service = TestJsonService(handler, RestMethod.get, 'test', restApiMock);

    await service.request();
    expect(handler.model, isNull);
    expect(handler.isOffline, isTrue);

    Locator().connectivity = AlwaysOnlineConnectivity();
  });

  test('JsonService GET socket error', () async {
    final restApiMock = RestApiMock<Map<String, dynamic>>(
      responseType: RestResponseType.unknown,
      content: {},
    );
    var handler = TestJsonServiceResponseHandler();
    var service = TestJsonService(handler, RestMethod.get, 'test', restApiMock);

    await service.request();
    expect(handler.model, isNull);
    expect(handler.errorType, RestResponseType.unknown);
  });
}

class TestJsonService
    extends JsonService<TestJsonRequestModel, TestJsonResponseModel> {
  TestJsonService(TestJsonServiceResponseHandler handler, RestMethod method,
      String path, RestApi restApi)
      : super(handler: handler, method: method, path: path, restApi: restApi);

  @override
  TestJsonResponseModel parseResponse(Map<String, dynamic> jsonResponse) {
    return TestJsonResponseModel.fromJson(jsonResponse);
  }
}

class TestJsonRequestModel implements JsonRequestModel {
  final String id;
  TestJsonRequestModel({this.id}) : assert(id != null);

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    return map;
  }
}

class NullableTestJsonRequestModel extends TestJsonRequestModel {
  final Map<String, dynamic> map;
  NullableTestJsonRequestModel(this.map) : super(id: '');

  @override
  Map<String, dynamic> toJson() {
    return map;
  }
}

class TestJsonResponseModel implements JsonResponseModel {
  final int field;
  final String optionalField;

  @override
  TestJsonResponseModel.fromJson(json)
      : field = json['field'] ?? 0,
        optionalField = json['optional_field'] ?? 'default';
}

class TestJsonServiceResponseHandler
    implements JsonServiceResponseHandler<TestJsonResponseModel> {
  TestJsonResponseModel model;
  RestResponseType errorType;
  Map<String, dynamic> invalidRequestModel;
  Map<String, dynamic> invalidResponse;
  bool isOffline;

  void reset() {
    model = null;
    errorType = null;
    invalidRequestModel = null;
    invalidResponse = null;
    isOffline = null;
  }

  @override
  void onError(RestResponseType responseType, Map<String, dynamic> content) {
    errorType = responseType;
  }

  @override
  void onInvalidRequest(Map<String, dynamic> requestJson) {
    invalidRequestModel = requestJson;
  }

  @override
  void onMissingPathData(Map<String, dynamic> requestJson) {
    invalidRequestModel = requestJson;
  }

  @override
  void onInvalidResponse(Map<String, dynamic> responseJson) {
    invalidResponse = responseJson;
  }

  @override
  void onNoConnectivity() {
    isOffline = true;
  }

  @override
  void onSuccess(TestJsonResponseModel responseModel) {
    model = responseModel;
  }
}

class NoConnectivity implements Connectivity {
  @override
  Future<ConnectivityStatus> getConnectivityStatus() {
    return Future.value(ConnectivityStatus.offline);
  }

  @override
  void registerConnectivityChangeListener(listener) {}
}
