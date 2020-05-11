import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

Future<String> getAppVersion() async {
  String version = '6.0.20200209';

  /// When running tests, platform information doesn't work, so we are relying
  /// for now on checking the proxy flag to disable the version check. This
  /// should be replaced with a proper environment detection.
  if (kReleaseMode) {
    var versionData = await PackageInfo.fromPlatform();
    if (versionData != null) version = '${versionData.version}';
  }

  return version;
}
