import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework_example/example_feature/api/example_service.dart';
import 'package:clean_framework_example/example_feature/api/example_service_response_model.dart';
import 'package:mockito/mockito.dart';

class ExampleServiceMock extends Mock implements ExampleService {
  static JsonServiceResponseHandler mockHandler;
  ExampleServiceMock();

  factory ExampleServiceMock.success() {
    final mock = ExampleServiceMock();
    when(mock.request(requestModel: anyNamed('requestModel')))
        .thenAnswer((_) async {
      mockHandler.onSuccess(ExampleServiceResponseModel.fromJson({
        'lastLogin': '2020-01-01',
        'loginCount': 5,
      }));
    });
    return mock;
  }
}
