import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/example_feature/api/example_service.dart';
import 'package:clean_framework_example/example_feature/api/example_service_response_model.dart';
import 'package:clean_framework_example/example_locator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  logger().setLogLevel(LogLevel.verbose);

  /// To execute this test, Mockey has to be running with the XML provided in the example folder
  test('ExampleService success', () async {
    final service = ExampleService();
    final eitherResponse = await service.request();

    expect(eitherResponse.isRight, isTrue);
    expect(
        eitherResponse.fold((_) {}, (m) => m),
        ExampleServiceResponseModel.fromJson(
            {'lastLogin': '2020-05-01', 'loginCount': 3}));
  });
}
