import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework_example/example_feature/api/example_service.dart';
import 'package:clean_framework_example/example_feature/api/example_service_response_model.dart';
import 'package:clean_framework_example/example_locator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  logger().setLogLevel(LogLevel.verbose);

  /// To execute this test, Mockey has to be running with the XML provided in the example folder
  test('ExampleService success', () async {
    final handlerMock =
        JsonServiceResponseHandlerMock<ExampleServiceResponseModel>();
    final service = ExampleService(handler: handlerMock);
    await service.request();
    final response = handlerMock.responseModel;

    expect(response, isA<ExampleServiceResponseModel>());
    expect(response.lastLogin, '2020-05-01');
    expect(response.loginCount, 3);
  });
}
