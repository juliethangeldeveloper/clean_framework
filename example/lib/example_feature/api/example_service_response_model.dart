import 'package:clean_framework/service/json_service.dart';

class ExampleServiceResponseModel extends JsonResponseModel {
  final String lastLogin;
  final int loginCount;

  ExampleServiceResponseModel.fromJson(Map<String, dynamic> json)
      : lastLogin = json['lastLogin'] ?? '',
        loginCount = json['loginCount'] ?? 0;
}
