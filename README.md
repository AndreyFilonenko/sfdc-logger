# Simple Salesforce Apex logger

[![CircleCI](https://circleci.com/gh/AndreyFilonenko/sfdc-logger.svg?style=svg)](https://circleci.com/gh/AndreyFilonenko/sfdc-logger) [![codecov](https://codecov.io/gh/AndreyFilonenko/sfdc-logger/branch/main/graph/badge.svg)](https://codecov.io/gh/AndreyFilonenko/sfdc-logger)

<a href="https://githubsfdeploy.herokuapp.com?owner=AndreyFilonenko&repo=sfdc-logger&ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Overview
A minimalistic logger for your Salesforce Apex code. 

## Usage
### Log methods usage
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

## License
The MIT License (MIT). Please see [License File](LICENSE) for more information.