import 'package:clean_framework/clean_framework.dart';

class ExampleEntity extends Entity {
  DateTime _lastLogin = DateTime.now();

  DateTime get lastLogin {
    return assertErrorState(_lastLogin);
  }

  set lastLogin(DateTime value) {
    _lastLogin = setData(value);
  }

  int _loginCount = 0;

  int get loginCount {
    return assertErrorState(_loginCount);
  }

  set loginCount(int value) {
    _loginCount = setData(value);
  }
}
