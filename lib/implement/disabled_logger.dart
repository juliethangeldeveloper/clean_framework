import 'package:clean_framework/logger.dart';

class DisabledLogger extends Logger {
  @override
  void setLogLevel(LogLevel level) {}

  @override
  void fatal(message, [error, StackTrace stackTrace]) {}

  @override
  void error(message, [error, StackTrace stackTrace]) {}

  @override
  void warning(message, [error, StackTrace stackTrace]) {}

  @override
  void info(message, [error, StackTrace stackTrace]) {}

  @override
  void debug(message, [error, StackTrace stackTrace]) {}

  @override
  void verbose(message, [error, StackTrace stackTrace]) {}
}
