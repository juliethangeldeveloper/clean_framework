import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:equatable/equatable.dart';

class PaymentServiceResponseModel extends Equatable
    implements JsonResponseModel {
  final bool didSucceed;

  PaymentServiceResponseModel.fromJson(Map<String, dynamic> json)
      : didSucceed = true;

  @override
  List<Object> get props => [didSucceed];
}
