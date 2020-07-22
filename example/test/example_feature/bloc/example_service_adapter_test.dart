import 'package:clean_framework_example/example_feature/api/example_service_response_model.dart';
import 'package:clean_framework_example/example_feature/bloc/example_service_adapter.dart';
import 'package:clean_framework_example/example_feature/model/example_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Repository', () {
    final entity = ExampleServiceAdapter().createEntity(
        ExampleEntity(),
        ExampleServiceResponseModel.fromJson({
          'lastLogin': '2020-01-01',
          'loginCount': 3,
        }));

    expect(entity,
        ExampleEntity(lastLogin: DateTime.parse('2020-01-01'), loginCount: 3));
  });
}
