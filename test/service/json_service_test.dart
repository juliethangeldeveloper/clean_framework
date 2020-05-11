import 'package:clean_framework/bloc/handled_response_type.dart';
import 'package:clean_framework/service/json_service.dart';
import 'package:clean_framework/service/rest_api.dart';
import 'package:clean_framework/service/service.dart';
import 'package:clean_framework/test/response_error_handler_mock.dart';
import 'package:clean_framework/test/rest_api_mock.dart';
import 'package:flutter_test/flutter_test.dart';

import 'service_json_mocks.dart';

void main() {
  //enableLogger();

  test('JsonService asserts', () async {
    expect(
        () =>
            NullService(restApi: null, handler: null, method: null, path: null),
        throwsAssertionError);
  });

  test('JsonService Success default', () async {
    var handler = ResponseErrorHandlerMock();
    var getService = TestService(handler);

    TestJsonResponseModel response = await getService.request();

    expect(handler.handledResponseType, isNull);
    expect(response, isNotNull);
    expect(response.field, 123);
    expect(response.optionalField, 'default');
  });

  test('JsonService Success with path variable', () async {
    var handler = ResponseErrorHandlerMock();
    var getService = TestService(handler);

    var request = TestJsonRequestModel(id: '123');

    TestJsonResponseModel response =
        await getService.request(requestModel: request);

    expect(handler.handledResponseType, isNull);
    expect(response, isNotNull);
    expect(response.field, 123);
    expect(response.optionalField, 'default');
  });

  test('JsonService network errors', () async {
    var handler = ResponseErrorHandlerMock();

    var res = await TestService(handler,
            restApi: RestApiFailureMock(RestResponseType.timeOut))
        .request();
    expect(handler.handledResponseType, HandledResponseType.noConnectivity);
    expect(res, isNull);

    res = await TestService(handler,
            restApi: RestApiFailureMock(RestResponseType.badRequest))
        .request();
    expect(handler.handledResponseType, HandledResponseType.serverError);
    expect(res, isNull);

    res = await TestService(handler,
            restApi: RestApiFailureMock(RestResponseType.notFound))
        .request();
    expect(handler.handledResponseType, HandledResponseType.serverError);
    expect(res, isNull);

    res = await TestService(handler,
            restApi: RestApiFailureMock(RestResponseType.conflict))
        .request();
    expect(handler.handledResponseType, HandledResponseType.serverError);
    expect(res, isNull);

    res = await TestService(handler,
            restApi: RestApiFailureMock(RestResponseType.unauthorized))
        .request();
    expect(handler.handledResponseType, HandledResponseType.invalidSession);
    expect(res, isNull);

    res = await TestService(handler,
            restApi: RestApiFailureMock(RestResponseType.unknown))
        .request();
    expect(handler.handledResponseType, HandledResponseType.serverError);
    expect(res, isNull);
  });

  test('JsonService error due to missing path variable', () async {
    var handler = ResponseErrorHandlerMock();
    var getService = TestServiceWithPathVariable(handler);

    /// Missing request model
    TestJsonResponseModel response = await getService.request();

    expect(handler.handledResponseType, HandledResponseType.missingPathData);
    expect(response, isNull);
    handler.reset();

    /// Request model with missing field
    var request = TestJsonRequestModelWithMap({});

    response = await getService.request(requestModel: request);

    expect(handler.handledResponseType, HandledResponseType.missingPathData);
    expect(response, isNull);
  });

  test('JsonService error due to null fields in request', () async {
    var handler = ResponseErrorHandlerMock();
    var getService = TestService(handler);

    /// Request model with null field
    var request = TestJsonRequestModelWithMap({'id': null});

    var response = await getService.request(requestModel: request);

    expect(handler.handledResponseType, HandledResponseType.invalidRequest);
    expect(response, isNull);
    handler.reset();

    /// Request model with nested null field
    request = TestJsonRequestModelWithMap({
      'nested': {'id': null}
    });

    response = await getService.request(requestModel: request);

    expect(handler.handledResponseType, HandledResponseType.invalidRequest);
    expect(response, isNull);
  });

  test('JsonService unexpected content', () async {
    var handler = ResponseErrorHandlerMock();

    /// A service is created that has a mock response with empty content
    /// should not create an error
    var result =
        await TestService(handler, restApi: RestApiSuccessMock({})).request();

    expect(result, isA<TestJsonResponseModel>());
    expect(handler.handledResponseType, isNull);
    handler.reset();

    /// An Unexpected Content error will be triggered if an exception happens
    /// inside the parseJson method:

    result =
        await TestService(handler, restApi: RestApiSuccessMock(getInvalidJson))
            .request();

    expect(handler.handledResponseType, HandledResponseType.unexpectedContent);
    expect(result, isNull);
  });
//
//  test('JsonService with Custom Handler', () async {
//    var handler = TestCustomResponseHandler();
//    var getService = TestServiceCustomHandler(handler,
//        fuseApi: MockFuseAPI.withConflictResponse());
//    TestJsonResponseModel response = await getService.request();
//    expect(response, isNull);
//    expect(handler.result, null);
//    expect(handler.hasCustomError, true);
//  });
//
//  test('JsonService Success Maintenance Window - Scheduled', () async {
//    var handler = TestResponseHandler();
//
//    var scheduledMaintenanceData = json.decode(
//        '{'EmergencyMaintWindow' : 'false', 'ScheduledMaintWindow' : 'true', '
//        ''ScheduledMaintText' : 'The Huntington app is currently unavailable '
//        'due to regularly scheduled system maintenance.<br><br>The system is '
//        'scheduled to be available by 6:00 AM ET. Thank you for banking '
//        'with Huntington.'}');
//
//    var getService = TestService(handler,
//        restApi: MockFuseAPI.simple(scheduledMaintenanceData));
//    TestJsonResponseModel response = await getService.request();
//    expect(response, isNull);
//    expect(handler.result, isNull);
//    expect(handler.model, isNotNull);
//    expect(handler.model.type, MaintenanceWindowType.scheduled);
//    expect(handler.model.message, isNotEmpty);
//  });
//
//  test('JsonService Success Maintenance Window - Emergency', () async {
//    var handler = TestResponseHandler();
//
//    var emergencyMaintenanceData = json.decode(
//        '{'EmergencyMaintWindow' : 'true','
//        ''ScheduledMaintWindow' : 'false','
//        ''EmergencyMaintText' : 'The Huntington app is currently unavailable '
//        'to regularly scheduled system maintenance.<br><br>The system is '
//        'scheduled to be available by 6:00 AM ET. Thank you for banking '
//        'with Huntington.'}');
//
//    var getService = TestService(handler,
//        restApi: MockFuseAPI.simple(emergencyMaintenanceData));
//    TestJsonResponseModel response = await getService.request();
//    expect(response, isNull);
//    expect(handler.result, isNull);
//    expect(handler.model, isNotNull);
//    expect(handler.model.type, MaintenanceWindowType.emergency);
//    expect(handler.model.message, isNotEmpty);
//  });
//
//  test('HuntingtonGetService Success with CachePolicy ', () async {
//    var handler = TestResponseHandler();
//    var getService = TestServiceWithCachePolicy(handler,
//        fuseApi: MockFuseAPI.successful(),
//        cachePolicy: DurationCachePolicy(Duration(minutes: 1)));
//    TestJsonResponseModel response = await getService.request();
//    expect(response, isNotNull);
//    expect(response.field, 'success');
//    expect(handler.result, isNull);
//  });
}

class TestJsonRequestModel implements JsonRequestModel {
  final String id;

  TestJsonRequestModel({this.id});

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
    };
  }
}

class TestJsonRequestModelWithMap extends TestJsonRequestModel {
  final Map<String, dynamic> map;
  TestJsonRequestModelWithMap(this.map) : super(id: '');

  @override
  Map<String, dynamic> toJson() {
    return map;
  }
}

class TestJsonResponseModel implements JsonResponseModel {
  final int field;
  final String optionalField;

  TestJsonResponseModel.fromJson(Map<String, dynamic> json)
      : field = json['field'] ?? 0,
        optionalField = json['optional_field'] ?? 'default';
}

class NullService extends JsonService<TestJsonRequestModel,
    TestJsonResponseModel, ResponseErrorHandler> {
  NullService(
      {RestApi restApi,
      ResponseErrorHandler handler,
      RestMethod method,
      String path})
      : super(restApi: restApi, path: path, handler: handler, method: method);

  @override
  TestJsonResponseModel parseJson(Map<String, dynamic> map) {
    return null;
  }
}

class TestService extends JsonService {
  TestService(ResponseErrorHandler handler, {RestApi restApi})
      : super(
          path: '/api3/test',
          method: RestMethod.get,
          handler: handler,
          restApi: restApi ?? RestApiSuccessMock(getSuccessJson),
        );

  @override
  TestJsonResponseModel parseJson(Map<String, dynamic> json) {
    return TestJsonResponseModel.fromJson(json);
  }
}

class TestServiceWithPathVariable extends JsonService {
  TestServiceWithPathVariable(ResponseErrorHandler handler)
      : super(
          path: '/api3/test/{id}',
          method: RestMethod.get,
          handler: handler,
          restApi: RestApiSuccessMock(getSuccessJson),
        );

  @override
  TestJsonResponseModel parseJson(Map<String, dynamic> json) {
    return TestJsonResponseModel.fromJson(json);
  }
}

//abstract class CustomResponseHandler extends ResponseErrorHandler {
//  void onCustomError();
//}
//
//class TestCustomResponseHandler extends TestResponseHandler
//    implements CustomResponseHandler {
//  bool hasCustomError = false;
//
//  void onCustomError() {
//    hasCustomError = true;
//  }
//}
//
//class TestServiceCustomHandler extends JsonService<
//    TestJsonResponseModel, TestCustomResponseHandler> {
//  TestServiceCustomHandler(TestCustomResponseHandler handler,
//      {FuseAPI fuseApi})
//      : super(
//            path: '/api3/test',
//            method: RestMethod.get,
//            handler: handler,
//            isCached: true,
//            restApi: fuseApi);
//
//  @override
//  TestJsonResponseModel parseJson(Map<String, dynamic> json) {
//    return TestJsonResponseModel.fromJson(json);
//  }
//
//  @override
//  bool serviceErrorHandler(response, handler) {
//    if (response.statusCode == 409) {
//      handler.onCustomError();
//      return true;
//    }
//    return false;
//  }
//}
