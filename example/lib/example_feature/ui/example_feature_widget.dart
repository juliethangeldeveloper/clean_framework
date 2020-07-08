import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/example_feature/bloc/example_bloc.dart';
import 'package:flutter/material.dart';

import 'example_presenter.dart';

class ExampleFeatureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExampleBloc>(
      create: (_) => ExampleBloc(),
      child: ExamplePresenter(),
    );
  }
}
