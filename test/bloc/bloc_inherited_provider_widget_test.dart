import 'package:clean_framework/bloc/bloc.dart';
import 'package:clean_framework/bloc/bloc_inherited_provider.dart';
import 'package:clean_framework/bloc/pipes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const String loadingText = 'loading...';
const String firstText = 'first';
const String secondText = 'second';

class TestBloc extends Bloc {
  String content;

  EventPipe getContent = EventPipe();
  Pipe<String> contentPipe = Pipe<String>();

  TestBloc({this.content = firstText}) {
    getContent.listen(() => contentPipe.send(content));
  }

  @override
  void dispose() {}
}

class TestContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TestContainerState();
  }
}

class TestContainerState extends State<TestContainer> {
  TestBloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: bloc.contentPipe.receive,
        builder: (context, snapshot) {
          return Text(snapshot.data ?? loadingText);
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocInheritedProvider.of(context);
    bloc.getContent.launch();
  }
}

void main() {
  testWidgets('BlocInheritedProvider', (WidgetTester tester) async {
    var bloc = TestBloc();
    await tester.pumpWidget(MaterialApp(
        home: BlocInheritedProvider(bloc: bloc, child: TestContainer())));
    await tester.pumpAndSettle();

    expect(find.text(firstText), findsOneWidget);

    bloc.content = secondText;
    bloc.getContent.launch();
    await tester.pumpAndSettle();

    expect(find.text(secondText), findsOneWidget);
  });
}
