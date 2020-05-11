import 'package:clean_framework/implement/disabled_logger.dart';

import 'logger.dart';

class Locator {
  static Locator instance;

  Locator._internal();
  factory Locator() {
    instance ??= Locator._internal();
    return instance;
  }

  final Logger logger = DisabledLogger();
}
