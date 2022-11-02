@isTest
private class CommissionTriggerHandlerTest {

    @isTest
    private static void testhandleNewCommission(){
        
        List<opportunity> oppList = new List<opportunity>(); 
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test Opp';
        objOpportunity.StageName = 'New';
        objOpportunity.Amount = 100;
        objOpportunity.CloseDate = system.Today()+3;
        oppList.add(objOpportunity);
        
        Opportunity objOpportunity2 = new Opportunity();
        objOpportunity2.Name = 'Test Opp1';
        objOpportunity2.StageName = 'Pending';
        objOpportunity2.Amount = 150;
        objOpportunity2.CloseDate = system.Today()+3;
        oppList.add(objOpportunity2);
        
        Opportunity objOpportunity3 = new Opportunity();
        objOpportunity3.Name = 'Test Opp2';
        objOpportunity3.StageName = 'Completed';
        objOpportunity3.Amount = 250;
        objOpportunity3.CloseDate = system.Today()+3;
        oppList.add(objOpportunity3);
        
        INSERT oppList;
        
        Sales_Agent__c agent = new Sales_Agent__c();
        agent.Name ='Test Agent';
        agent.Amount_Pending__c = 0;
        INSERT agent;
        
        Commission__c comm = new Commission__c();
        comm.Opportunity__c = objOpportunity.Id;
        comm.Sales_Agent__c = agent.Id;
        
        Test.startTest();
         INSERT comm;
 		Sales_Agent__c ag = [SELECT Id, Amount_Pending__c FROM Sales_Agent__c ];
        System.assertEquals(100,ag.Amount_Pending__c);
        
        objOpportunity.Amount = 1000;
        UPDATE objOpportunity;
        Sales_Agent__c agn = [SELECT Id, Amount_Pending__c FROM Sales_Agent__c ];
        System.assertEquals(1000,agn.Amount_Pending__c);
 		Test.stopTest();
        
        
    }
    
}