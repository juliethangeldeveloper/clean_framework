import 'package:clean_framework/clean_framework.dart';

abstract class Logger extends ExternalDependency {
  void setLogLevel(LogLevel level);

  void verbose(dynamic message, [dynamic error, StackTrace stackTrace]);

  void debug(dynamic message, [dynamic error, StackTrace stackTrace]);

  void info(dynamic message, [dynamic error, StackTrace stackTrace]);

  void warning(dynamic message, [dynamic error, StackTrace stackTrace]);

  void error(dynamic message, [dynamic error, StackTrace stackTrace]);

  void fatal(dynamic message, [dynamic error, StackTrace stackTrace]);
}

enum LogLevel { nothing, fatal, error, warning, info, debug, verbose }
