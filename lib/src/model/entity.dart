import 'package:clean_framework/clean_framework.dart';

abstract class Entity {
  PublishedErrorType _error;

  PublishedErrorType get error => _error;

  set error(PublishedErrorType value) {
    _error = value;
  }

  dynamic assertErrorState(dynamic data) {
    return (_error == null) ? data : throw Error();
  }

  dynamic setData(dynamic data) {
    _error = null;
    return data;
  }

  hasError() {
    return _error != null;
  }
}
