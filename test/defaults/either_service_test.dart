import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:test/test.dart';

import '../test_config.dart';

void main() {
  testConfig();

  test('EitherService GET success with empty response', () async {
    final restApiMock = RestApiMock<String>(
      responseType: RestResponseType.success,
      content: '',
    );
    final service =
        TestServiceWithEmptyResponse(RestMethod.get, 'test', restApiMock);

    final response = await service.request();
    expect(response.isRight, isTrue);
    response.fold((_) {}, (model) {
      expect(model, isA<EmptyJsonResponseModel>());
    });
  });

  test('EitherService GET success with custom response', () async {
    final restApiMock = RestApiMock<String>(
      responseType: RestResponseType.success,
      content: '{"field": 123}',
    );
    final service =
        TestServiceWithCustomResponse(RestMethod.get, 'test', restApiMock);

    final response = await service.request();
    expect(response.isRight, isTrue);
    response.fold((_) {}, (model) {
      expect(
          model, TestJsonResponseModel(field: 123, optionalField: 'default'));
    });
  });
}

class TestServiceWithEmptyResponse
    extends EitherService<JsonRequestModel, EmptyJsonResponseModel> {
  TestServiceWithEmptyResponse(RestMethod method, String path, RestApi restApi)
      : super(method: method, path: path, restApi: restApi);

  @override
  EmptyJsonResponseModel parseResponse(Map<String, dynamic> jsonResponse) {
    return EmptyJsonResponseModel();
  }
}

class TestServiceWithCustomResponse
    extends EitherService<JsonRequestModel, TestJsonResponseModel> {
  TestServiceWithCustomResponse(RestMethod method, String path, RestApi restApi)
      : super(method: method, path: path, restApi: restApi);

  @override
  TestJsonResponseModel parseResponse(Map<String, dynamic> jsonResponse) {
    return TestJsonResponseModel.fromJson(jsonResponse);
  }
}

class TestJsonResponseModel extends JsonResponseModel {
  final int field;
  final String optionalField;

  TestJsonResponseModel({this.field, this.optionalField});

  @override
  List<Object> get props => [field, optionalField];

  @override
  TestJsonResponseModel.fromJson(json)
      : field = json['field'] ?? 0,
        optionalField = json['optional_field'] ?? 'default';
}
