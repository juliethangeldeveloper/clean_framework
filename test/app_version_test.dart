import 'package:clean_framework/app_version.dart';
import 'package:test/test.dart';

main() {
  test('AppVersion default', () async {
    String version = await getAppVersion();
    expect(version, '6.0.20200209');
  });
}
