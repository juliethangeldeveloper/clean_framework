import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework_example/example_feature/api/example_service.dart';
import 'package:clean_framework_example/example_feature/api/example_service_response_model.dart';
import 'package:clean_framework_example/example_feature/model/example_business_model.dart';
import 'package:clean_framework_example/example_feature/model/example_view_model.dart';
import 'package:flutter/material.dart';

export 'package:clean_framework_example/example_feature/model/example_view_model.dart';

class ExampleBloc extends ErrorPublisherBloc {
  ExampleService _exampleService;
  @visibleForTesting
  JsonResponseBlocHandler<ExampleBloc, ExampleServiceResponseModel>
      exampleServiceHandler;

  ExampleBusinessModel _businessModel = ExampleBusinessModel();

  final exampleViewModelPipe = Pipe<ExampleViewModel>();

  @override
  void dispose() {
    exampleViewModelPipe.dispose();
  }

  ExampleBloc({ExampleService exampleService}) {
    exampleServiceHandler =
        JsonResponseBlocHandler<ExampleBloc, ExampleServiceResponseModel>(
            bloc: this, success: _exampleServiceSuccess);
    _exampleService =
        exampleService ?? ExampleService(handler: exampleServiceHandler);

    exampleViewModelPipe.onListen(_exampleViewModelListener);
  }

  void _exampleViewModelListener() async {
    await _exampleService.request();
    // If the request is successful, the business model already holds the response
    // values at this point.
    exampleViewModelPipe.send(await _exampleViewModel);
  }

  Future<ExampleViewModel> get _exampleViewModel async {
    return ExampleViewModel(
        lastLogin: _businessModel.lastLogin,
        loginCount: _businessModel.loginCount);
  }

  void _exampleServiceSuccess(ExampleServiceResponseModel responseModel) {
    _businessModel
      ..lastLogin = DateTime.tryParse(responseModel.lastLogin) ?? DateTime.now()
      ..loginCount = responseModel.loginCount;
  }
}
