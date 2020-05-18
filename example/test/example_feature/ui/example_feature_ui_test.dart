import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework_example/example_feature/bloc/example_bloc.dart';
import 'package:clean_framework_example/example_feature/ui/example_feature_widget.dart';
import 'package:clean_framework_example/example_feature/ui/example_presenter.dart';
import 'package:clean_framework_example/example_feature/ui/example_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../api/example_service_mock.dart';
import '../bloc/example_bloc_mock.dart';

void main() {
  testWidgets('ExampleFeature screen with data from view model',
      (tester) async {
    final bloc = ExampleBloc(exampleService: ExampleServiceMock.success());
    ExampleServiceMock.mockHandler = bloc.exampleServiceHandler;

    final testWidget = MaterialApp(
        home: BlocProvider(
      create: (_) => bloc,
      child: ExampleFeatureWidget(),
    ));

    await tester.pumpWidget(testWidget);
    await tester.pump(Duration(milliseconds: 500));

    expect(find.byType(ExampleScreen), findsOneWidget);
    expect(find.text('2020-01-01'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('ExampleFeatureWidget no mocks, but with a response handler',
      (tester) async {
    final testWidget = MaterialApp(
        home: BlocProvider<ExampleBloc>(
            create: (_) => ExampleBloc(),
            child: TestResponseHandlerWidget<ExampleBloc>(
                onError: expectAsync1((errorType) {
                  expect(errorType, PublishedErrorType.general);
                }),
                child: ExampleFeatureWidget())));

    await tester.pumpWidget(testWidget);
    await tester.pump(Duration(milliseconds: 500));

    expect(find.byType(ExamplePresenter), findsOneWidget);
  });

  testWidgets('ExampleFeature, with mocked bloc', (tester) async {
    final testWidget = MaterialApp(
        home: BlocProvider<ExampleBloc>(
            create: (_) => ExampleBlocMock(), child: ExampleFeatureWidget()));

    await tester.pumpWidget(testWidget);
    await tester.pump(Duration(milliseconds: 500));

    expect(find.byType(ExamplePresenter), findsOneWidget);
  });
}
