import 'package:clean_framework/bloc/bloc.dart';
import 'package:clean_framework/logger.dart';
import 'package:clean_framework/ui/presenter.dart';
import 'package:clean_framework/ui/screen.dart';
import 'package:clean_framework_example/example_feature/bloc/example_bloc.dart';
import 'package:clean_framework_example/example_feature/model/example_view_model.dart';
import 'package:clean_framework_example/example_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  logger().setLogLevel(LogLevel.verbose);
  runApp(ExampleFeatureWidget());
}

class ExampleFeatureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocInheritedProvider(
      bloc: ExampleBloc(),
      child: ExamplePresenter(),
    );
  }
}

class ExamplePresenter extends Presenter<ExampleBloc, ExampleViewModel> {
  @override
  Stream<ExampleViewModel> getViewModelStream(ExampleBloc bloc) {
    return bloc.exampleViewModelPipe.receive;
  }

  @override
  Widget buildScreen(BuildContext context, ExampleViewModel viewModel) {
    return ExampleScreen();
  }
}

class ExampleScreen extends Screen {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
