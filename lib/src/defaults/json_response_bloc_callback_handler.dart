import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';

typedef SuccessCallback<M extends ServiceResponseModel> = void Function(
    M model);
typedef ErrorCallback = void Function(PublishedErrorType model);

class JsonResponseBlocCallbackHandler<M extends JsonResponseModel>
    implements JsonServiceResponseHandler<M> {
  final SuccessCallback<M> success;
  final ErrorCallback error;

  JsonResponseBlocCallbackHandler({this.success, this.error})
      : assert(error != null),
        assert(success != null);

  @override
  void onError(RestResponseType responseType, String response) {
    error(PublishedErrorType.general);
  }

  @override
  void onMissingPathData(Map<String, dynamic> requestJson) {
    error(PublishedErrorType.general);
  }

  @override
  void onInvalidRequest(Map<String, dynamic> requestJson) {
    error(PublishedErrorType.general);
  }

  @override
  void onInvalidResponse(String response) {
    error(PublishedErrorType.general);
  }

  @override
  void onNoConnectivity() {
    error(PublishedErrorType.noConnectivity);
  }

  @override
  void onSuccess(M model) => success(model);
}
