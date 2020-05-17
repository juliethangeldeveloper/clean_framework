import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';

class ResponseHandlerMock<M extends JsonResponseModel>
    implements JsonServiceResponseHandler<M> {
  PublishedErrorType errorType;
  M responseModel;

  void reset() => errorType = null;

  @override
  void onError(RestResponseType responseType, Map<String, dynamic> content) =>
      errorType = PublishedErrorType.general;

  @override
  void onInvalidRequest(Map<String, dynamic> requestJson) =>
      errorType = PublishedErrorType.general;

  @override
  void onInvalidResponse(Map<String, dynamic> responseJson) =>
      errorType = PublishedErrorType.general;

  @override
  void onMissingPathData(Map<String, dynamic> requestJson) =>
      errorType = PublishedErrorType.general;

  @override
  void onNoConnectivity() {
    // TODO: implement onNoConnectivity
  }

  @override
  void onSuccess(M model) => responseModel = model;
}
