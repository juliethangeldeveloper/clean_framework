import 'dart:async';

import 'package:clean_framework/bloc/pipes.dart';
import 'package:clean_framework/models.dart';
import 'package:test/test.dart';

void main() async {
  test('Pipe', () async {
    Pipe<bool> testPipe = Pipe<bool>(initialData: false);
    expect(testPipe.initialData, false);

    testPipe.receive.listen(expectAsync1((value) {
      expect(value, true);
      testPipe.dispose();
    }));

    //TODO Not sure how to test for bad state, this doesn't work:
//    expect(testPipe.receive.listen((_) {}),
//        throwsA(const TypeMatcher<StateError>()));

    testPipe.send(true);
  }, timeout: Timeout(Duration(seconds: 2)));

  test('Pipe throw error', () async {
    Pipe<bool> testPipe = Pipe<bool>(initialData: false);
    expect(testPipe.initialData, false);
    testPipe.receive.listen(((value) {}), onError: (error) {
      expect(error == 'Error', true);
      testPipe.dispose();
    });
    expect(testPipe.hasListeners, true);
    testPipe.throwError('Error');
  }, timeout: Timeout(Duration(seconds: 2)));

  test('BroadcastPipe', () async {
    BroadcastPipe<bool> testPipe = BroadcastPipe<bool>(initialData: false);
    expect(testPipe.initialData, false);
    expect(testPipe.hasListeners, false);

    testPipe.receive.listen(expectAsync1((value) => expect(value, true)));
    testPipe.receive.listen(expectAsync1((value) {
      expect(value, true);
      testPipe.dispose();
    }));
    expect(testPipe.hasListeners, true);

    testPipe.send(true);
  }, timeout: Timeout(Duration(seconds: 2)));

  test('ViewModelBroadcastPipe', () async {
    TestModel testModel = TestModel();
    ViewModelBroadcastPipe<TestModel> testPipe =
        ViewModelBroadcastPipe<TestModel>(initialData: testModel);
    expect(testPipe.initialData.result, 'test value');
    expect(testPipe.hasListeners, false);

    testPipe.receive.listen(expectAsync1((value) => expect(value, isNotNull)));
    testPipe.receive.listen(expectAsync1((value) {
      expect(value, isNotNull);
      expect(value.result, isNotNull);
      expect(value.result, 'test value');

      testPipe.dispose();
    }));
    expect(testPipe.hasListeners, true);

    testPipe.send(testModel);
  }, timeout: Timeout(Duration(seconds: 2)));

  test('EventPipe', () async {
    EventPipe testPipe = EventPipe();
    expect(testPipe.receive, isNull);

    testPipe.listen(expectAsync0(() {
      expect(true, true);
      testPipe.dispose();
    }));

    testPipe.launch();
  }, timeout: Timeout(Duration(seconds: 2)));

  test('EventPipe error', () async {
    EventPipe testPipe = EventPipe();

    testPipe.listen(expectAsync0(() {}, count: 0), onError: expectAsync1((_) {
      testPipe.dispose();
    }));

    testPipe.throwError('');
  }, timeout: Timeout(Duration(seconds: 2)));

  test('BroadcastEventPipe', () async {
    BroadcastEventPipe testPipe = BroadcastEventPipe();
    expect(testPipe.hasListeners, false);

    testPipe.listen(expectAsync0(() {}));
    testPipe.listen(expectAsync0(() {
      testPipe.dispose();
    }));
    expect(testPipe.hasListeners, true);
    expect(testPipe.receive, isNull);

    testPipe.launch();
  }, timeout: Timeout(Duration(seconds: 2)));

  test('BroadcastEventPipe error', () async {
    BroadcastEventPipe testPipe = BroadcastEventPipe();

    testPipe.listen(expectAsync0(() {}, count: 0), onError: expectAsync1((_) {
      testPipe.dispose();
    }));

    testPipe.throwError('');
  }, timeout: Timeout(Duration(seconds: 2)));

  test('ValidatorPipe', () async {
    ValidatorPipe<String> testPipe = ValidatorPipe<String>('', testValidator);

    String text = 'test';
    var subscriptionWithValidation;
    var normalListenerSubscription;

    // This subscription doesn't update the isValid value, and its meant to
    // used on StreamBuilders only.
    normalListenerSubscription = testPipe.receive.listen((newValue) {
      expect(newValue, text);
      normalListenerSubscription.cancel();
    });

    // This is the subscription that updates isValid correctly, and the one
    // that should be used by custom listeners.
    subscriptionWithValidation = testPipe.listen(expectAsync1((newValue) {
      expect(testPipe.isValid, true);
      expect(newValue, text);
      subscriptionWithValidation.cancel();

      // Nested expectAsync1 to avoid having to fall back to awaits that don't
      // make sure the event is launched
      subscriptionWithValidation = testPipe.listen(expectAsync1((newValue) {
        expect(testPipe.isValid, false);
        expect(newValue, isNull);
        subscriptionWithValidation.cancel();
        testPipe.dispose();
      }));

      testPipe.send('');
    }));

    testPipe.send(text);
  }, timeout: Timeout(Duration(seconds: 2)));
}

var testValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (incomingValue, sink) {
  if (incomingValue.isNotEmpty) {
    sink.add(incomingValue);
  } else {
    sink.addError('error');
  }
});

class TestModel extends ViewModel {
  final String result;
  TestModel({this.result = 'test value'});
}
