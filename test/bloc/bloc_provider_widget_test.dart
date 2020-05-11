import 'package:clean_framework/bloc/bloc.dart';
import 'package:clean_framework/bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockBloc extends Bloc {
  var content = 'test';

  @override
  void dispose() {}
}

class TestContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MockBloc bloc = BlocProvider.of(context);

    return Text(bloc.content);
  }
}

void main() {
  testWidgets('PROXY DEV BlocProvider', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: BlocProvider(bloc: MockBloc(), child: TestContainer())));
    await tester.pumpAndSettle();

    expect(find.text('test'), findsOneWidget);
  });
}
