import 'package:clean_framework/implement/simple_rest_api.dart';
import 'package:clean_framework/service/rest_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SimpleRestApi success get', () async {
    final client = SimpleRestApi(); // Default constructor uses Mockey baseUrl

    final response = await client.request(
      method: RestMethod.get,
      uri: 'api/mobile/2.2/features',
    );

    expect(response, allOf(isNotNull, isA<RestResponse>()));
    expect(response.type, RestResponseType.success);
    expect(response.content.isNotEmpty, isTrue);
  });

  test('SimpleRestApi failure get', () async {
    final client = SimpleRestApi(baseUrl: 'http://fake');

    final response = await client.request(
      method: RestMethod.get,
      uri: 'api/mobile/2.2/features',
    );

    expect(response, allOf(isNotNull, isA<RestResponse>()));
    expect(response.type, RestResponseType.unknown);
    expect(response.content.isEmpty, isTrue);
  });
}
