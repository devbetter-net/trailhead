public with sharing class AddPrimaryContact implements Queueable {
    private Contact contact;
    private String state;

    public AddPrimaryContact(Contact inputContact, String inputState) {
        this.contact = inputContact;
        this.state = inputState;
    }

    public void execute(QueueableContext context) {
        //Retrive 200 Account records
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 200];

        //Create empty list of Contact records
        List<Contact> contacts = new List<Contact>();

        //Iterate through the Account records
        for (Account account : accounts) {
            //Clone the Contact record, make the clone a child of the specified Account
            Contact contactClone = contact.clone();
            contactClone.AccountId = account.Id;
            contacts.add(contactClone);
        }
        
        //Insert the list of Contact records
        insert contacts;
    }
}