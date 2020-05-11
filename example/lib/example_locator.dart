import 'package:clean_framework/implement/console_logger.dart';
import 'package:clean_framework/implement/simple_rest_api.dart';
import 'package:clean_framework/locator.dart';
import 'package:clean_framework/logger.dart';

ExampleLocator locator() => ExampleLocator();
Logger logger() => ExampleLocator().logger;

class ExampleLocator implements Locator {
  ExampleLocator._();
  factory ExampleLocator() {
    Locator.instance ??= ExampleLocator._();
    return Locator.instance;
  }

  @override
  Logger logger = ConsoleLogger(LogLevel.nothing);
  SimpleRestApi api = SimpleRestApi();
}
