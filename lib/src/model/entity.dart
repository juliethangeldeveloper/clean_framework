import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Entity extends Equatable {
  final List<EntityError> errors;

  @override
  bool get stringify => true;

  Entity({this.errors = const []});
  bool hasErrors() => errors.isNotEmpty;
  bool hasError(EntityError error) => errors.indexOf(error) > 0;

  merge({errors}) {
    return Entity(errors: errors);
  }

  @override
  List<Object> get props => [errors];
}

class EntityError {
  const EntityError();
}

class GeneralError extends EntityError {}

class NoConnectivityError extends EntityError {}
