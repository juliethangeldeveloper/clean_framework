import 'package:clean_framework/implement/console_logger.dart';
import 'package:clean_framework/locator.dart';
import 'package:clean_framework/logger.dart';

class TestLocator implements Locator {
  TestLocator._();
  factory TestLocator() {
    Locator.instance ??= TestLocator._();
    return Locator.instance;
  }

  @override
  Logger logger = ConsoleLogger(LogLevel.nothing);
}

enableLogger() => TestLocator().logger.setLogLevel(LogLevel.verbose);
