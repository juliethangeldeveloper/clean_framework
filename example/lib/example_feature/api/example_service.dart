import 'package:clean_framework/service/json_service.dart';
import 'package:clean_framework/service/rest_api.dart';
import 'package:clean_framework/service/service.dart';
import 'package:clean_framework_example/example_feature/api/example_service_response_model.dart';
import 'package:clean_framework_example/example_locator.dart';

class ExampleService extends JsonService {
  ExampleService({
    ResponseErrorHandler handler,
  })  : assert(handler is ResponseErrorHandler),
        super(
            handler: handler,
            method: RestMethod.get,
            restApi: ExampleLocator().api,
            path: 'login-history');

  @override
  JsonResponseModel parseJson(Map<String, dynamic> map) {
    return ExampleServiceResponseModel.fromJson(map);
  }
}
