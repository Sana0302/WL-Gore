public class OpportunityTriggerHandler {
    
    
    public static void updateCommission(List<Opportunity> opportunities){
        
        //List of Sales Agents to be Updated
        List<Sales_Agent__c> salesAgentsToUpdate = new List<Sales_Agent__c>();
        
        Set<Id> salesAgentIds = new Set<Id>();
        Map<Id,Decimal> commissionOppMap = new Map<Id,Decimal>();
        Decimal amount = 0 ;
        for(Commission__c comm:[SELECT Id, Opportunity__c,Opportunity__r.Amount, Sales_Agent__c 
                                FROM Commission__c WHERE Opportunity__c IN:opportunities ]){
                                    
                                    if(comm.Sales_Agent__c!=null) {
                                       salesAgentIds.add(comm.Sales_Agent__c); 
                                    } 
            
             if(commissionOppMap.containsKey(comm.Sales_Agent__c)){
                 commissionOppMap.put(comm.Sales_Agent__c ,commissionOppMap.get(comm.Sales_Agent__c)+comm.Opportunity__r.Amount);
                                        
             }                       
                                    
             else{
                 commissionOppMap.put(comm.Sales_Agent__c ,comm.Opportunity__r.Amount); 
             }
        }
        
        
        //Preparing list of Sales Agents to Update
        for(Sales_Agent__c salesAgent:[SELECT Id, 
                                      Amount_Pending__c 
                                      FROM Sales_Agent__c WHERE Id IN: salesAgentIds]){
            
            salesAgent.Amount_Pending__c =  (Decimal)commissionOppMap.get(salesAgent.Id) ;                            
            salesAgentsToUpdate.add(salesAgent) ;                             
        }

        
        //Update List of Sales Agent records
        if(salesAgentsToUpdate!=null &&salesAgentsToUpdate.size()>0){
            UPDATE salesAgentsToUpdate;
        }
        
        
        
    }
    
}