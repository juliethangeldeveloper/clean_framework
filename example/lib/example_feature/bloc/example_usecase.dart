import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/example_feature/api/example_service_response_model.dart';
import 'package:clean_framework_example/example_feature/model/example_entity.dart';
import 'package:clean_framework_example/example_feature/model/example_view_model.dart';

class ExampleUseCase extends UseCase {
  // ExampleEntity _exampleEntity = ExampleEntity();
  final ExampleEntity _exampleEntity;

  ExampleUseCase({exampleEntity}) : _exampleEntity = exampleEntity;

  //  void setResponse(ExampleServiceResponseModel responseModel){
  //  void setResponse(ExampleServiceResponseModel responseModel, PublishedErrorType errorType){

  void setEntitySnapshot(EntitySnapshot<ExampleServiceResponseModel> snapshot) {
    if (snapshot.hasData()) {
      _exampleEntity
        ..lastLogin =
            DateTime.tryParse(snapshot.data.lastLogin) ?? DateTime.now()
        ..loginCount = snapshot.data.loginCount;
    }

    if (snapshot.hasError()) {
      //_exampleEntity = ExampleEntityWithDataError();

      _exampleEntity.error = snapshot.error;
    }
  }

  ExampleViewModel get exampleViewModel {
    //  if (_exampleEntity  is ExampleEntityWithDataError)

    if (_exampleEntity.hasError()) {
      return ExampleViewModel(
          lastLogin: DateTime.now(),
          loginCount: 0,
          error: _exampleEntity.error);
    } else {
      return ExampleViewModel(
          lastLogin: _exampleEntity.lastLogin,
          loginCount: _exampleEntity.loginCount);
    }
  }
}

class EntitySnapshot<D> {
  final D _data;
  final PublishedErrorType _error;

  EntitySnapshot({D data, PublishedErrorType error})
      : _data = data,
        _error = error {
    if ((this._data == null && this._error == null) ||
        (this._data != null && this._error != null)) {
      throw Error();
    }
  }

  D get data {
    return _data;
  }

  PublishedErrorType get error {
    return _error;
  }

  bool hasData() {
    return _data != null;
  }

  bool hasError() {
    return _error != null;
  }
}

class ExampleEntityWithDataError extends ExampleEntity implements DataError {
  @override
  StackTrace get stackTrace {
    return null;
  }
}

class ExampleEntityWithNetworkError extends ExampleEntity
    implements NetworkError {
  @override
  StackTrace get stackTrace {
    return null;
  }
}

class DataError extends Error {}

class NetworkError extends Error {}
