import 'package:clean_framework/logger.dart';
import 'package:clean_framework_example/example_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  logger().setLogLevel(LogLevel.verbose);
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Text('Example App'),
      ),
    );
  }
}
