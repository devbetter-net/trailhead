/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AccountProcessorTest {

   @isTest
    static void testCountContacts() {

        // Create test Accounts
        Account acc1 = new Account(Name = 'Test Account 1');
        Account acc2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{ acc1, acc2 };

        // Create Contacts for acc1
        List<Contact> contacts = new List<Contact>{
            new Contact(LastName = 'Contact 1', AccountId = acc1.Id),
            new Contact(LastName = 'Contact 2', AccountId = acc1.Id),
            new Contact(LastName = 'Contact 3', AccountId = acc1.Id)
        };
        insert contacts;

        // Call future method
        Test.startTest();
        AccountProcessor.countContacts(
            new List<Id>{ acc1.Id, acc2.Id }
        );
        Test.stopTest();

        // Retrieve updated accounts
        Map<Id, Account> updatedAccounts = new Map<Id, Account>(
            [SELECT Number_Of_Contacts__c FROM Account WHERE Id IN :new List<Id>{ acc1.Id, acc2.Id }]
        );

        // Assertions
        System.assertEquals(
            3,
            updatedAccounts.get(acc1.Id).Number_Of_Contacts__c,
            'Account 1 should have 3 contacts'
        );

        System.assertEquals(
            0,
            updatedAccounts.get(acc2.Id).Number_Of_Contacts__c,
            'Account 2 should have 0 contacts'
        );
    }
}