import 'package:clean_framework/bloc/pipes.dart';
import 'package:clean_framework/service/service.dart';

import 'bloc.dart';

class ResponseHandlerBloc extends Bloc implements ResponseErrorHandler {
  static final String noListenersException =
      'Response Handler has no listeners';

  BroadcastPipe<HandledResponseType> responseHandlerResultPipe =
      BroadcastPipe<HandledResponseType>();

  @override
  void onInvalidRequest() {
    if (!responseHandlerResultPipe.hasListeners)
      throw noListenersException;
    else
      responseHandlerResultPipe.send(HandledResponseType.invalidRequest);
  }

  @override
  void onInvalidSession() {
    if (!responseHandlerResultPipe.hasListeners)
      throw noListenersException;
    else
      responseHandlerResultPipe.send(HandledResponseType.invalidSession);
  }

  @override
  void onServerError() {
    if (!responseHandlerResultPipe.hasListeners)
      throw noListenersException;
    else
      responseHandlerResultPipe.send(HandledResponseType.serverError);
  }

  @override
  void onUnexpectedContent() {
    if (!responseHandlerResultPipe.hasListeners)
      throw noListenersException;
    else
      responseHandlerResultPipe.send(HandledResponseType.unexpectedContent);
  }

  @override
  void dispose() {
    responseHandlerResultPipe.dispose();
  }

  @override
  void onMissingPathData() {
    // TODO: implement onMissingPathData
  }

  @override
  void onNoConnectivity() {
    // TODO: implement onNoConnectivity
  }
}
