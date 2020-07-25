import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SimpleRestApi success get', () async {
    final client = SimpleRestApi(); // Default constructor uses Mockey baseUrl

    final response = await client.request(
      method: RestMethod.get,
      path: 'api/mobile/2.2/features',
    );

    expect(response, allOf(isNotNull, isA<RestResponse>()));
    expect(response.type, RestResponseType.success);
    expect(response.content.isNotEmpty, isTrue);

    //TODO Allow dependency injection later to make this testable
  }, skip: true);

  test('SimpleRestApi failure get', () async {
    final client = SimpleRestApi(baseUrl: 'http://fake');

    final response = await client.request(
      method: RestMethod.get,
      path: 'api/mobile/2.2/features',
    );

    expect(response, allOf(isNotNull, isA<RestResponse>()));
    expect(response.type, RestResponseType.unknown);
    expect(response.content.isEmpty, isTrue);
  });
}
