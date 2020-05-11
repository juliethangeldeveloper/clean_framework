import 'package:clean_framework/models.dart';

class ExampleViewModel extends ViewModel {
  final DateTime lastLogin;
  final int loginCount;

  ExampleViewModel({this.lastLogin, this.loginCount = 0})
      : assert(lastLogin is DateTime);
}
