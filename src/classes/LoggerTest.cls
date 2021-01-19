@isTest
private class LoggerTest {
    @isTest
    private static void testLogGeneric() {
        Profile adminProfile = [
            SELECT Id 
            FROM Profile 
            WHERE Name = 'System Administrator'
            LIMIT 1
        ];
        User adminUser = new User(
            Alias = 'adm',
            Country = 'United Kingdom',
            Email = 'adm.user@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'admin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = adminProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'adm.user@test.com'
        );
        insert adminUser;

        Test.startTest();
        System.runAs(adminUser) {
            Logger.log(Logger.LogSeverity.DEBUG, 'Test Debug message');
        }
        Logger.commitLogs();
        Test.stopTest();
        
        Log__c log = [
            SELECT Id,
                   Severity__c,
                   Message__c,
                   Running_User__c,
                   Logged_at__c
            FROM Log__c
            LIMIT 1
        ];

        System.assertEquals('DEBUG', log.Severity__c);
        System.assertEquals('Test Debug message', log.Message__c);
        System.assertEquals(adminUser.Id, log.Running_User__c);
        System.assertNotEquals(null, log.Logged_at__c);
    }

    @isTest
    private static void testLogSpecified() {
        Test.startTest();
        Logger.logSuccess('Test Success message');
        Logger.logError('Test Error message');
        Logger.logInfo('Test Info message');
        Logger.commitLogs();
        Test.stopTest();
        
        Integer logsCount = [
            SELECT COUNT()
            FROM Log__c
        ];

        System.assertEquals(3, logsCount);
    }
}