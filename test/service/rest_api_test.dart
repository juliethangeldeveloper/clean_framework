import 'package:clean_framework/clean_framework.dart';
import 'package:test/test.dart';

void main() {
  test('RestResponse asserts', () {
    expect(() => RestResponse(content: null, uri: null),
        throwsA(isA<AssertionError>()));
    expect(() => RestResponse(content: '', uri: null),
        throwsA(isA<AssertionError>()));
  });
}
