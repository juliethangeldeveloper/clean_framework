import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:equatable/equatable.dart';

class ExampleServiceResponseModel extends Equatable
    implements JsonResponseModel {
  final String lastLogin;
  final int loginCount;

  ExampleServiceResponseModel.fromJson(Map<String, dynamic> json)
      : lastLogin = json['lastLogin'] ?? '',
        loginCount = json['loginCount'] ?? 0;

  @override
  List<Object> get props => [lastLogin, loginCount];
}
