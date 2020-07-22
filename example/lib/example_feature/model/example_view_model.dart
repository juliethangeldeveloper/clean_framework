import 'package:clean_framework/clean_framework.dart';

class ExampleViewModel extends ViewModel {
  final DateTime lastLogin;
  final int loginCount;

  ExampleViewModel({this.lastLogin, this.loginCount})
      : assert(lastLogin is DateTime && loginCount != null);
}
