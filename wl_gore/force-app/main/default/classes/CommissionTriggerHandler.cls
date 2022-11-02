public class CommissionTriggerHandler {
    
    
    public static void handleNewCommission(List<Commission__c> commissions ){
        
        Map<Id,Decimal> commissionOppMap = new Map<Id,Decimal>();
        List<Sales_Agent__c> salesAgentsToUpdate = new List<Sales_Agent__c>();
        
        //Getting  IDs for  relatd Opportunity and Sales Agents Records
        Set<Id> salesAgentIds = new Set<Id>();
        Set<Id> opportunityIds = new Set<Id>();
        for(Commission__c comm:commissions){
            if(comm.Opportunity__c!=null ){
              opportunityIds.add(comm.Opportunity__c)  ;
            }
            if(comm.Sales_Agent__c!=null){
              salesAgentIds.add(comm.Sales_Agent__c)  ;
            }

        }
        
        //Updating commissionOppMap with Opportunity Amount
        for(Commission__c commission:[SELECT Id, 
                                      Opportunity__c,Sales_Agent__c,
                                      Opportunity__r.Amount 
                                      FROM Commission__c WHERE Opportunity__c IN: opportunityIds]){
            
              if(commissionOppMap.containsKey(commission.Sales_Agent__c)){
                  commissionOppMap.put(commission.Sales_Agent__c ,commissionOppMap.get(commission.Sales_Agent__c)+commission.Opportunity__r.Amount);
                                              
              }                       
                                          
              else{
                  commissionOppMap.put(commission.Sales_Agent__c ,commission.Opportunity__r.Amount); 
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