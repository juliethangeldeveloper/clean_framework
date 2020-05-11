import 'dart:async';

import 'package:clean_framework/bloc/bloc.dart';
import 'package:clean_framework_example/example_feature/model/example_view_model.dart';

class ExampleBloc extends Bloc {
  final exampleViewModelPipe = ViewModelBroadcastPipe<ExampleViewModel>();

  ExampleBloc() {
    exampleViewModelPipe.onListen(_exampleViewModelListener);
  }

  void _exampleViewModelListener() async {
    exampleViewModelPipe.send(await _exampleViewModel);
  }

  Future<ExampleViewModel> get _exampleViewModel async {
    return ExampleViewModel();
  }
}
