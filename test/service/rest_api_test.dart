import 'package:clean_framework/service/rest_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RestResponse asserts', () {
    expect(() => RestResponse(content: null, uri: null), throwsAssertionError);
  });
}
