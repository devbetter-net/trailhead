@isTest
public class LeadProcessorTest {

    @isTest
    private static void testBatchClass(){
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++){
            leads.add(new Lead(LastName = 'Kyle', Company ='Saleforce'));            
        }
        insert leads;
        //Perform the test
       	Test.startTest();
        LeadProcessor processor = new LeadProcessor();
        Id batchId = Database.executeBatch(processor, 200);
        Test.stopTest();
        
        List<Lead> updatedLeads = [SELECT ID FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.assertEquals(200, updatedLeads.size(), 'ERROR: At least 1 Lead record not update correctly');
    }
}