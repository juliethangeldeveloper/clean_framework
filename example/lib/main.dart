import 'dart:async';

import 'package:clean_framework/clean_framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'example_feature/bloc/example_bloc.dart';
import 'example_feature/model/example_view_model.dart';
import 'example_locator.dart';

void main() {
  logger().setLogLevel(LogLevel.verbose);
  runApp(ExampleFeatureWidget());
}

class ExampleFeatureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExampleBloc>(
      create: (_) => ExampleBloc(),
      child: ExamplePresenter(),
    );
  }
}

class ExamplePresenter
    extends Presenter<ExampleBloc, ExampleViewModel, ExampleScreen> {
  @override
  Stream<ExampleViewModel> getViewModelStream(ExampleBloc bloc) {
    return bloc.exampleViewModelPipe.receive;
  }

  @override
  ExampleScreen buildScreen(
      BuildContext context, ExampleBloc bloc, ExampleViewModel viewModel) {
    return ExampleScreen();
  }
}

class ExampleScreen extends Screen {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
