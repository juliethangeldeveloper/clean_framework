import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/example_feature/bloc/example_bloc.dart';
import 'package:clean_framework_example/example_feature/ui/example_feature_widget.dart';
import 'package:clean_framework_example/example_feature/ui/example_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../bloc/example_bloc_mock.dart';

void main() {
  testWidgets('ExampleFeature, with mocked bloc', (tester) async {
    final testWidget = MaterialApp(
        home: BlocProvider<ExampleBloc>(
            create: (_) => ExampleBlocMock(), child: ExampleFeatureWidget()));

    await tester.pumpWidget(testWidget);
    await tester.pump(Duration(milliseconds: 500));

    expect(find.byType(ExamplePresenter), findsOneWidget);
  });
}
