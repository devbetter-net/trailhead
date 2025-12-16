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
private class AddPrimaryContactTest {

    @isTest
    static void testQueueableClass() {
        // Load test data
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 500; i++) {
            Account acc = new Account(Name = 'Test Account ' + i);
            if (i < 250)
            {
                acc.BillingState = 'NY';
            }
            else
            {
                acc.BillingState = 'CA';
            }
            accounts.add(acc);
        }
        insert accounts;

        // Create test Contact
        Contact contact = new Contact(FirstName = 'FirstName Contact', LastName = 'LastName Contact');
        insert contact;

        //Perform test
        Test.startTest();
        AddPrimaryContact addPrimaryContact = new AddPrimaryContact(contact, 'NY');
        System.enqueueJob(addPrimaryContact);
        Test.stopTest();

        //check if the contact is updated
        List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE Contact.Account.BillingState = 'NY'];
        System.Assert.areEqual(200, contacts.size());
        System.Assert.areEqual(contact.Id, contacts.get(0).AccountId);

    }
}