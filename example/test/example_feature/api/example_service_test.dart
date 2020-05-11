import 'package:clean_framework/logger.dart';
import 'package:clean_framework/test/response_error_handler_mock.dart';
import 'package:clean_framework_example/example_feature/api/example_service.dart';
import 'package:clean_framework_example/example_feature/api/example_service_response_model.dart';
import 'package:clean_framework_example/example_locator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  logger().setLogLevel(LogLevel.verbose);
  test('ExampleService success', () async {
    final handlerMock = ResponseErrorHandlerMock();
    final service = ExampleService(handler: handlerMock);
    final ExampleServiceResponseModel response = await service.request();

    expect(response, isA<ExampleServiceResponseModel>());
    expect(response.lastLogin, '2020-05-01');
    expect(response.loginCount, 3);
  });
}
