import 'package:clean_framework/src/defaults/either_service.dart';
import 'package:clean_framework/src/defaults/json_service.dart';

import '../model/entity.dart';

abstract class ServiceAdapter<E extends Entity, R extends JsonRequestModel,
    M extends JsonResponseModel, S extends EitherService<R, M>> {
  final S _service;

  ServiceAdapter(S service, {R requestModel})
      : assert(service != null),
        _service = service;

  Future<Entity> query(E initialEntity) async {
    final eitherResponse =
        await _service.request(requestModel: createRequest(initialEntity));
    return eitherResponse.fold(
        (error) => createEntityWithError(initialEntity, error),
        (responseModel) {
          final errorClearedEntity = initialEntity.merge(errors: <EntityError>[]);
          return createEntity(errorClearedEntity, responseModel);
        });
  }

  E createEntity(E initialEntity, M responseModel);
  E createEntityWithError(E initialEntity, ServiceError error) {
    if (error is NoConnectivityServiceError)
      return initialEntity.merge(errors: [NoConnectivityError()]);
    return initialEntity.merge(errors: [GeneralError()]);
  }

  /// override if needed
  R createRequest(E entity) {
    return null;
  }
}
