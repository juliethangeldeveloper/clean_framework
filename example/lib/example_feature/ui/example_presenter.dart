import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/example_feature/bloc/example_bloc.dart';
import 'package:flutter/material.dart';

import 'example_screen.dart';

class ExamplePresenter
    extends Presenter<ExampleBloc, ExampleViewModel, ExampleScreen> {
  @override
  Stream<ExampleViewModel> getViewModelStream(ExampleBloc bloc) {
    return bloc.exampleViewModelPipe.receive;
  }

  @override
  ExampleScreen buildScreen(
      BuildContext context, ExampleBloc bloc, ExampleViewModel viewModel) {
    return ExampleScreen(viewModel: viewModel);
  }
}
