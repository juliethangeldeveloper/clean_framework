import 'package:clean_framework/bloc/handled_response_type.dart';
import 'package:clean_framework/service/service.dart';

class ResponseErrorHandlerMock implements ResponseErrorHandler {
  HandledResponseType handledResponseType;

  void reset() => handledResponseType = null;

  @override
  void onInvalidSession() =>
      handledResponseType = HandledResponseType.invalidSession;

  @override
  void onMissingPathData() =>
      handledResponseType = HandledResponseType.missingPathData;

  @override
  void onNoConnectivity() =>
      handledResponseType = HandledResponseType.noConnectivity;

  @override
  void onInvalidRequest() =>
      handledResponseType = HandledResponseType.invalidRequest;

  @override
  void onServerError() => handledResponseType = HandledResponseType.serverError;

  @override
  void onUnexpectedContent() =>
      handledResponseType = HandledResponseType.unexpectedContent;
}
