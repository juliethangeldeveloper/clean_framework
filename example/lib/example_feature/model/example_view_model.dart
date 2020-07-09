import 'package:clean_framework/clean_framework.dart';

class ExampleViewModel extends ViewModel {
  final DateTime lastLogin;
  final int loginCount;
  final dynamic error;

  ExampleViewModel({this.lastLogin, this.loginCount = 0, this.error})
      : assert(lastLogin is DateTime);
}
