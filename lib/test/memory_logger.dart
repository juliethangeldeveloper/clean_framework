import 'package:clean_framework/logger.dart';

export 'package:clean_framework/logger.dart';

class MemoryLogger extends Logger {
  LogLevel _level = LogLevel.verbose;
  StringBuffer _logBuffer = StringBuffer('');

  MemoryLogger(LogLevel level) : _level = level;

  String get dump => _logBuffer.toString();

  void clear() => _logBuffer.clear();

  @override
  void setLogLevel(LogLevel level) => _level = level;

  @override
  void fatal(message, [error, StackTrace stackTrace]) {
    if (_level.index >= LogLevel.fatal.index) _logBuffer.write('$message\n');
  }

  @override
  void error(message, [error, StackTrace stackTrace]) {
    if (_level.index >= LogLevel.error.index) _logBuffer.write('$message\n');
  }

  @override
  void warning(message, [error, StackTrace stackTrace]) {
    if (_level.index >= LogLevel.warning.index) _logBuffer.write('$message\n');
  }

  @override
  void info(message, [error, StackTrace stackTrace]) {
    if (_level.index >= LogLevel.info.index) _logBuffer.write('$message\n');
  }

  @override
  void debug(message, [error, StackTrace stackTrace]) {
    if (_level.index >= LogLevel.debug.index) _logBuffer.write('$message\n');
  }

  @override
  void verbose(message, [error, StackTrace stackTrace]) {
    if (_level.index >= LogLevel.verbose.index) _logBuffer.write('$message\n');
  }
}
