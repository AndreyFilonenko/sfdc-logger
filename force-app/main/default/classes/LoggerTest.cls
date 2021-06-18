@IsTest
private class LoggerTest {
    private static final String ADMIN_USER_NAME = 'adm.user14649@test.logger.com';
    private static final String STANDARD_USER_NAME = 'std.user12309@test.logger.com';

    @TestSetup
    private static void makeData() {
        Profile adminProfile = [
            SELECT Id 
            FROM Profile 
            WHERE Name = 'System Administrator'
            LIMIT 1
        ];
        Profile standardUserProfile = [
            SELECT Id 
            FROM Profile 
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        List<User> usersToInsert = new List<User>();   
        User adminUser = new User(
            Alias = 'adm',
            Country = 'United Kingdom',
            Email = ADMIN_USER_NAME,
            EmailEncodingKey = 'UTF-8',
            LastName = 'admin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = adminProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = ADMIN_USER_NAME
        );
        usersToInsert.add(adminUser);
        User standardUser = new User(
            Alias = 'suser',
            Country = 'United Kingdom',
            Email = STANDARD_USER_NAME,
            EmailEncodingKey = 'UTF-8',
            LastName = 'Standard User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = standardUserProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = STANDARD_USER_NAME
        );
        usersToInsert.add(standardUser);
        insert usersToInsert;

        System.runAs(adminUser) {
            List<Logger_Config__c> configs = new List<Logger_Config__c>();
            Logger_Config__c defaultConfig = new Logger_Config__c();
            defaultConfig.SetupOwnerId = UserInfo.getOrganizationId();
            defaultConfig.Is_Logger_Enabled__c = false;
            defaultConfig.Is_Debug_Enabled__c = false;
            defaultConfig.Is_Info_Enabled__c = false;
            defaultConfig.Is_Success_Enabled__c = false;
            defaultConfig.Is_Error_Enabled__c = false;
            configs.add(defaultConfig);

            
            Logger_Config__c standardUserConfig = new Logger_Config__c();
            standardUserConfig.SetupOwnerId = standardUser.Id;
            standardUserConfig.Is_Logger_Enabled__c = true;
            standardUserConfig.Is_Debug_Enabled__c = true;
            standardUserConfig.Is_Info_Enabled__c = true;
            standardUserConfig.Is_Success_Enabled__c = true;
            standardUserConfig.Is_Error_Enabled__c = true;
            configs.add(standardUserConfig);
            insert configs;
        }
    }

    @IsTest
    private static void testLogDisabled() {
        User adminUser = [
            SELECT Id
            FROM User
            WHERE UserName = :ADMIN_USER_NAME
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(adminUser) {
            Logger.logDebug('Test Debug message');
            Logger.logInfo('Test Debug message');
            Logger.logSuccess('Test Debug message');
            Logger.logError('Test Debug message');
            Logger.commitLogs();
        }
        Test.stopTest();
        
        Integer logsCount = [
            SELECT COUNT()
            FROM Log__c
            WHERE Running_User__c = :adminUser.Id
        ];

        System.assertEquals(0, logsCount);
    }


    @IsTest
    private static void testLogEnabled() {
        User standardUser = [
            SELECT Id
            FROM User
            WHERE UserName = :STANDARD_USER_NAME
            LIMIT 1
        ];

        Test.startTest();
        System.runAs(standardUser) {
            Logger.logDebug('Test Debug message');
            Logger.logInfo('Test Debug message');
            Logger.logSuccess('Test Debug message');
            Logger.logError('Test Debug message');
            Logger.commitLogs();
        }
        Test.stopTest();
        
        Integer debugLogsCount = [
            SELECT COUNT()
            FROM Log__c
            WHERE Running_User__c = :standardUser.Id
            AND Severity__c = :Logger.LogSeverity.DEBUG.name()
        ];
        Integer infoLogsCount = [
            SELECT COUNT()
            FROM Log__c
            WHERE Running_User__c = :standardUser.Id
            AND Severity__c = :Logger.LogSeverity.INFO.name()
        ];
        Integer successLogsCount = [
            SELECT COUNT()
            FROM Log__c
            WHERE Running_User__c = :standardUser.Id
            AND Severity__c = :Logger.LogSeverity.SUCCESS.name()
        ];
        Integer errorLogsCount = [
            SELECT COUNT()
            FROM Log__c
            WHERE Running_User__c = :standardUser.Id
            AND Severity__c = :Logger.LogSeverity.ERROR.name()
        ];

        System.assertEquals(1, debugLogsCount);
        System.assertEquals(1, infoLogsCount);
        System.assertEquals(1, successLogsCount);
        System.assertEquals(1, errorLogsCount);
    }
}