void main() {
//  FuseAPI.isProxyEnabled = true;
//  var logContent = 'foo';
//
//  test('HNBLogger log all levels', () {
//    HNBLogger.logDestination = LogDestination.test;
//    HNBLogger.enableLog = true;
//
//    HNBLogger().error(logContent);
//    expect(HNBLogger.logs.toString().contains(logContent), isTrue);
//    HNBLogger.clearLogs();
//
//    HNBLogger().warning(logContent);
//    expect(HNBLogger.logs.toString().contains(logContent), isTrue);
//    HNBLogger.clearLogs();
//
//    HNBLogger().info(logContent);
//    expect(HNBLogger.logs.toString().contains(logContent), isTrue);
//    HNBLogger.clearLogs();
//
//    HNBLogger().debug(logContent);
//    expect(HNBLogger.logs.toString().contains(logContent), isTrue);
//    HNBLogger.clearLogs();
//
//    HNBLogger().verbose(logContent);
//    expect(HNBLogger.logs.toString().contains(logContent), isTrue);
//    HNBLogger.clearLogs();
//  });
//
//  test('HNBLogger when log destination is none', () {
//    HNBLogger.logDestination = LogDestination.none;
//    HNBLogger.enableLog = true;
//
//    HNBLogger().error(logContent);
//    //none of the logs are recorded if HNBLogger.logDestination = LogDestination.none
//    // and get logs returns 'Logs Not Recorded'
//    expect(HNBLogger.logs.toString(), equals('Logs Not Recorded'));
//    HNBLogger.clearLogs();
//    HNBLogger.enableLog = false;
//    HNBLogger.logDestination = LogDestination.console;
//  });
//
//  test('HNBLogger logs disabled', () {
//    HNBLogger.logDestination = LogDestination.test;
//    HNBLogger.enableLog = false;
//
//    HNBLogger().error(logContent);
//    expect(HNBLogger.logs.toString().contains(logContent), isFalse);
//
//    HNBLogger().warning(logContent);
//    expect(HNBLogger.logs.toString().contains(logContent), isFalse);
//
//    HNBLogger().info(logContent);
//    expect(HNBLogger.logs.toString().contains(logContent), isFalse);
//
//    HNBLogger().debug(logContent);
//    expect(HNBLogger.logs.toString().contains(logContent), isFalse);
//
//    HNBLogger().verbose(logContent);
//    expect(HNBLogger.logs.toString().contains(logContent), isFalse);
//  });
//
//  test('HNBLogger logs on error level', () {
//    HNBLogger.logDestination = LogDestination.test;
//    HNBLogger.enableLog = true;
//
//    HNBLogger().error(logContent);
//    expect(HNBLogger.logs.toString().contains(logContent), isTrue);
//    HNBLogger.clearLogs();
//
//    HNBLogger().warning(logContent);
//    expect(HNBLogger.logs.toString().contains(logContent), isFalse);
//
//    HNBLogger().info(logContent);
//    expect(HNBLogger.logs.toString().contains(logContent), isFalse);
//
//    HNBLogger().debug(logContent);
//    expect(HNBLogger.logs.toString().contains(logContent), isFalse);
//
//    HNBLogger().verbose(logContent);
//    expect(HNBLogger.logs.toString().contains(logContent), isFalse);
//  });
//
//  test('HNBLogger when log destination is console', () {
//    HNBLogger.logDestination = LogDestination.console;
//    HNBLogger.enableLog = true;
//
//    HNBLogger().error(logContent);
//    //logs are recorded to console if HNBLogger.logDestination = LogDestination.console
//    //and get logs returns 'Logs Sent To Console'
//    expect(HNBLogger.logs.toString(), equals('Logs Sent To Console'));
//    HNBLogger.clearLogs();
//    HNBLogger.enableLog = false;
//    HNBLogger.logDestination = LogDestination.console;
//  });
//
//  test('HNBLogger when log destination is splunk', () {
//    HNBLogger.logDestination = LogDestination.splunk;
//    HNBLogger.enableLog = true;
//
//    HNBLogger().error(logContent);
//    //logs sent to Splunk if HNBLogger.logDestination = LogDestination.splunk
//    // and get logs returns 'Logs Sent To Splunk'
//    expect(HNBLogger.logs.toString(), equals('Logs Sent To Splunk'));
//    HNBLogger.clearLogs();
//    HNBLogger.enableLog = false;
//    HNBLogger.logDestination = LogDestination.console;
//  });
}
