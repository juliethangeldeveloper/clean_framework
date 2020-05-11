import 'package:clean_framework/locator.dart';
import 'package:clean_framework/logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Locator', () {
    Locator().logger.setLogLevel(LogLevel.verbose);
    Locator().logger.error('This won\'t get printed');
  });
}
