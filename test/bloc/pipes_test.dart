import 'package:clean_framework/clean_framework.dart';
import 'package:test/test.dart';

void main() {
  test('Pipe sends data', () async {
    Pipe<bool> testPipe = Pipe<bool>(initialData: true);
    expect(testPipe.hasListeners, isFalse);
    expect(testPipe.initialData, true);
    testPipe.receive.listen(expectAsync1((value) {
      expect(value, true);
      testPipe.dispose();
    }));
    expect(testPipe.hasListeners, isTrue);
    testPipe.send(true);
  }, timeout: Timeout(Duration(seconds: 3)));

  test('Pipe emits data in order', () async {
    Pipe<int> testPipe = Pipe(initialData: 0);
    expect(testPipe.hasListeners, isFalse);
    expect(testPipe.initialData, 0);
    expectLater(
      testPipe.receive,
      emitsInOrder([
        1,
        2,
        3,
      ]),
    );

    testPipe..send(1)..send(2)..send(3);
  }, timeout: Timeout(Duration(seconds: 3)));

  test('Pipe throws an error', () async {
    Pipe<bool> testPipe = Pipe<bool>();
    expect(testPipe.hasListeners, isFalse);
    testPipe.receive.listen(expectAsync1((_) {}, max: 0, count: 0),
        onError: expectAsync1((error) {
      expect(error, isNotNull);
      testPipe.dispose();
    }));
    expect(testPipe.hasListeners, isTrue);
    testPipe.throwError(Error());
  }, timeout: Timeout(Duration(seconds: 3)));

  test('EventPipe launches successfully', () async {
    EventPipe testPipe = EventPipe();
    expect(testPipe.hasListeners, isFalse);
    expect(testPipe.receive, isNull);

    testPipe.listen(expectAsync0(() {
      testPipe.dispose();
    }));

    expect(testPipe.hasListeners, isTrue);
    testPipe.launch();
  }, timeout: Timeout(Duration(seconds: 3)));
}
