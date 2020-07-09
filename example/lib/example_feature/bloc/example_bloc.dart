import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework_example/example_feature/api/example_service.dart';
import 'package:clean_framework_example/example_feature/api/example_service_response_model.dart';
import 'package:clean_framework_example/example_feature/bloc/example_usecase.dart';
import 'package:clean_framework_example/example_feature/model/example_entity.dart';
import 'package:clean_framework_example/example_feature/model/example_view_model.dart';
import 'package:flutter/material.dart';

export 'package:clean_framework_example/example_feature/model/example_view_model.dart';

class ExampleBloc extends Bloc {
  ExampleService _exampleService;
  @visibleForTesting
  JsonResponseBlocCallbackHandler<ExampleServiceResponseModel>
      exampleServiceHandler;

  ExampleEntity _exampleEntity = ExampleEntity();
  ExampleUseCase _usecase;

  final exampleViewModelPipe = Pipe<ExampleViewModel>();

  @override
  void dispose() {
    exampleViewModelPipe.dispose();
  }

  ExampleBloc({ExampleService exampleService}) {
    _usecase = ExampleUseCase(exampleEntity: _exampleEntity);

    exampleServiceHandler =
        JsonResponseBlocCallbackHandler<ExampleServiceResponseModel>(
            success: _exampleServiceSuccess, error: _exampleServiceError);
    _exampleService =
        exampleService ?? ExampleService(handler: exampleServiceHandler);

    exampleViewModelPipe.onListen(_exampleViewModelListener);
  }

  void _exampleViewModelListener() async {
    await _exampleService.request();
    // If the request is successful, the business model already holds the response
    // values at this point.
    exampleViewModelPipe.send(_usecase.exampleViewModel);
  }

  void _exampleServiceSuccess(ExampleServiceResponseModel responseModel) {
    _usecase.setEntitySnapshot(EntitySnapshot(data: responseModel));
  }

  void _exampleServiceError(PublishedErrorType errorType) {
    _usecase.setEntitySnapshot(EntitySnapshot(error: errorType));
  }
}
