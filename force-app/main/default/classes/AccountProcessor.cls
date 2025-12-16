public with sharing class AccountProcessor {

    @future
    public static void countContacts(List<Id> accountIds) {

        // Map to store Account Id and Contact count
        Map<Id, Integer> contactCountMap = new Map<Id, Integer>();

        // Aggregate query to count contacts per account
        for (AggregateResult ar : [
            SELECT AccountId accId, COUNT(Id) totalContacts
            FROM Contact
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            contactCountMap.put(
                (Id) ar.get('accId'),
                (Integer) ar.get('totalContacts')
            );
        }

        // Prepare accounts for update
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountIds) {
            Integer countValue = contactCountMap.containsKey(accId)
                ? contactCountMap.get(accId)
                : 0;

            accountsToUpdate.add(
                new Account(
                    Id = accId,
                    Number_Of_Contacts__c = countValue
                )
            );
        }

        // Update accounts
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    
}