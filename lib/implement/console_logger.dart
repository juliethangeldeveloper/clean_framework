import 'package:clean_framework/logger.dart';

class ConsoleLogger extends Logger {
  LogLevel _level = LogLevel.verbose;

  ConsoleLogger(LogLevel level) : _level = level;

  @override
  void setLogLevel(LogLevel level) => _level = level;

  @override
  void fatal(message, [error, StackTrace stackTrace]) {
    if (_level.index >= LogLevel.fatal.index) print('[FATAL]: $message');
  }

  @override
  void error(message, [error, StackTrace stackTrace]) {
    if (_level.index >= LogLevel.error.index)
      print('[ERROR]: $message $error '
          '$stackTrace');
  }

  @override
  void warning(message, [error, StackTrace stackTrace]) {
    if (_level.index >= LogLevel.warning.index) print('[WARNING]: $message');
  }

  @override
  void info(message, [error, StackTrace stackTrace]) {
    if (_level.index >= LogLevel.info.index) print('[INFO]: $message');
  }

  @override
  void debug(message, [error, StackTrace stackTrace]) {
    if (_level.index >= LogLevel.debug.index) print('[DEBUG]: $message');
  }

  @override
  void verbose(message, [error, StackTrace stackTrace]) {
    if (_level.index >= LogLevel.verbose.index) print('[VERBOSE]: $message');
  }
}
