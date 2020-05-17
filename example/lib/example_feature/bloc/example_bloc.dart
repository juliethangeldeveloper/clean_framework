import 'dart:async';

import 'package:clean_framework/clean_framework.dart';

import '../model/example_view_model.dart';

class ExampleBloc extends Bloc {
  final exampleViewModelPipe = Pipe<ExampleViewModel>();

  ExampleBloc() {
    exampleViewModelPipe.onListen(_exampleViewModelListener);
  }

  void _exampleViewModelListener() async {
    exampleViewModelPipe.send(await _exampleViewModel);
  }

  Future<ExampleViewModel> get _exampleViewModel async {
    return ExampleViewModel();
  }

  @override
  void dispose() {
    exampleViewModelPipe.dispose();
  }
}
