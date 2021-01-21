# Simple Salesforce Apex logger

[![CircleCI](https://circleci.com/gh/AndreyFilonenko/sfdc-logger.svg?style=svg)](https://circleci.com/gh/AndreyFilonenko/sfdc-logger) [![codecov](https://codecov.io/gh/AndreyFilonenko/sfdc-logger/branch/main/graph/badge.svg)](https://codecov.io/gh/AndreyFilonenko/sfdc-logger)

<a href="https://githubsfdeploy.herokuapp.com?owner=AndreyFilonenko&repo=sfdc-logger&ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Overview
A minimalistic logger for your Salesforce Apex code. 

## Usage

### Logger public API
#### Enums:
* `Logger.LogSeverity` - an enum containing message severity types: `INFO`, `SUCCESS`, `ERROR` and `DEBUG`.

#### Methods:
* `static void log(Logger.LogSeverity severity, String message)` - a generic method for logging a message with a specific severity.
* `static void logInfo(String message)` - a method for logging a message with the predefined `INFO` severity.
* `static void logSuccess(String message)` - a method for logging a message with the predefined `SUCCESS` severity.
* `static void logError(String message)` - a method for logging a message with the predefined `ERROR` severity.
* `static void commitLogs()` - a method for committing logs to database if any.

### Logger methods usage
You can log different kind of messages using `logError`, `logSuccess` or `logInfo` methods, also it is possible to construct your own log message using a generic `log` method:
```java  
Logger.logError('Test Error message');
Logger.logSuccess('Test Success message');
Logger.logInfo('Test Info message');

Logger.log(Logger.LogSeverity.DEBUG, 'Test Debug message');
```

Dont forget to call `commitLogs` method in the end of your execution context or another suitable place:
```java  
Logger.commitLogs();
```

The typical usage of logger is in `try...catch...finally` blocks:
```java
try {
    // Some glitchy code
    throw new NullPointerException('error message');
} catch (Exception ex) {
    Logger.logError(ex.getMessage());
} finally {
    Logger.commitLogs();
}
```

### Additional features
* You can easily add an on-off switch to the logger functionality by using the custom setting (checkbox):
    1. Create a new hierarchy custom setting or use the existing one.
    2. Add new checkbox named `Is_Logger_Enabled__c` to it.
    3. Uncomment line 3 in Logger class and replace the `YOUR_CUSTOM_SETTING` with your custom setting name, remove line 2.
    4. You can integrate the logger switch in any other way you want.


## License
The MIT License (MIT). Please see [License File](LICENSE) for more information.