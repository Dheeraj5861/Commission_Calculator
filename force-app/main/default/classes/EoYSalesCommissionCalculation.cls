/************************************************************************* 
Batch Class Name :- EoYSalesCommissionCalculation
Created By :Samiteon Team 
Purpose :- It will calculate End of year Commission of sales rep for which we have to calculate commission for financial year.
************************************************************************/

public class EoYSalesCommissionCalculation implements Database.Batchable<sObject>,Schedulable{    
    /*********************************************************** 
It will query the calculated December month data      
**********************************************************/
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'Select Id,EoY_Sales_Commission__r.Commission_Master__c,EoY_Sales_Commission__r.Commission_Master__r.recordType.Name,Employee__c,Cumulative_Tile_Margin__c,Cumulative_Ancillary_Margin__c,Total_Margin_Without_Split__c,Cumulative_Total_Sale__c,Cumulative_Total_Margin__c,Cumulative_Eligible_Margin__c,Total_Commission__c,Paid_Commission__c from Monthly_Commission__c Where CALENDAR_MONTH(createdDate)=12 AND createdDate=LAST_YEAR';
        return Database.getQueryLocator(query);   
    }
    public void execute(Database.BatchableContext bc, List<Monthly_Commission__c> monthlyCommissions){
        System.debug('monthlyCommissions ::==>>'+monthlyCommissions);
        Set<Id> commissionMasterIds = new Set<Id>();
        Set<id> eoySalesId = new Set<id>();
        Map<Id,Commission_Master__c> commissionMasterById = new Map<Id,Commission_Master__c>();
        Map<Id,List<Commission_Tier__c>> commissionTierByCommissionMaster = new Map<Id,List<Commission_Tier__c>>();
        Map<Id,Map<String,Decimal>> targetByTypeByCommissionMaster = new Map<Id,Map<String,Decimal>>();
        Map<Id,Map<String,Decimal>> eoyMarginTargetByTypeByCommissionMaster = new Map<Id,Map<String,Decimal>>();
        Map<Id,List<EoY_GP_Target_Bonus__c>> eoyGpTargetBonusByCommissionMaster = new Map<Id,List<EoY_GP_Target_Bonus__c>>(); 
        Map<String,Map<Id,Monthly_Commission__c>> monthlyCommissionByEOYSalesByProfile = new  Map<String,Map<Id,Monthly_Commission__c>>();
        Map<Id,Eoy_Sales_Commission__c> eoySalesCommissionById = new Map<Id,Eoy_Sales_Commission__c>();
        Map<String,Map<Id,Eoy_Sales_Commission__c>> eoySalesCommissionByIdByProfile = new Map<String,Map<Id,Eoy_Sales_Commission__c>>();
        List<Eoy_Sales_Commission__c> eoySalesCommissionToBeUpdated = new List<Eoy_Sales_Commission__c>();
        for( Monthly_Commission__c monthlyCommission : monthlyCommissions){
            commissionMasterIds.add(monthlyCommission.EoY_Sales_Commission__r.Commission_Master__c);
            eoySalesId.add(monthlyCommission.EoY_Sales_Commission__c);
            if(monthlyCommissionByEOYSalesByProfile.containsKey(monthlyCommission.employee__r.profile.name)){
                monthlyCommissionByEOYSalesByProfile.get(monthlyCommission.employee__r.profile.name).put(monthlyCommission.EoY_Sales_Commission__c,monthlyCommission);                 
            }
            else{
                monthlyCommissionByEOYSalesByProfile.put(monthlyCommission.employee__r.profile.name,new Map<id,Monthly_Commission__c>{monthlyCommission.EoY_Sales_Commission__c => monthlyCommission});
            }
        }
        
        eoySalesCommissionById = EoYSalesCommissionSelector.getEoySalesCommissionById(eoySalesId);
        for(EOY_Sales_Commission__c eoySalesCommission : eoySalesCommissionById.values()){
            if(eoySalesCommissionByIdByProfile.containsKey(eoySalesCommission.Employee__r.Profile.Name)){
                eoySalesCommissionByIdByProfile.get(eoySalesCommission.Employee__r.Profile.Name).put(eoySalesCommission.id,eoySalesCommission);
            }
            else{
                eoySalesCommissionByIdByProfile.put(eoySalesCommission.Employee__r.Profile.Name, new Map<Id,EOY_Sales_Commission__c>{eoySalesCommission.id => eoySalesCommission});
            }
        }        
        commissionMasterById = CommissionMasterSelector.getCommissionMasterById(commissionMasterIds);
        commissionTierByCommissionMaster = DataFactory.getsObjectsByFieldId(CommissionTierSelector.getCommissionTierByCommissionMasters(commissionMasterIds),'Commission_Master__c');
        eoyGpTargetBonusByCommissionMaster = DataFactory.getsObjectsByFieldId(EoYGPBonusTargetSelector.getEoYGPBonusTargetByCommissionMasters(commissionMasterIds),'Commission_Master__c');              
        
        for(GP_Percent_Target__c gpPercentTarget : GPPercentTargetSelector.getGPPercentTargetByCommissionMasters(commissionMasterIds)){            
            if(targetByTypeByCommissionMaster.containsKey(gpPercentTarget.Commission_Master__c)){
                targetByTypeByCommissionMaster.get(gpPercentTarget.Commission_Master__c).put(gpPercentTarget.Type__c,gpPercentTarget.Target_Percent__c);
            }
            else{
                targetByTypeByCommissionMaster.put(gpPercentTarget.Commission_Master__c,new Map<String,Decimal>{gpPercentTarget.Type__c => gpPercentTarget.Target_Percent__c});
            }
        }

        for(EOY_Margin_Target__c eoyMarginTarget : EOYMarginTargetSelector.getEoyMarginTargetByCommissionMaster(commissionMasterIds)){
            if(eoyMarginTargetByTypeByCommissionMaster.containsKey(eoyMarginTarget.Commission_Master__c)){
                eoyMarginTargetByTypeByCommissionMaster.get(eoyMarginTarget.Commission_Master__c).put(eoyMarginTarget.Type__c,eoyMarginTarget.Target__c);
            }
            else{
                eoyMarginTargetByTypeByCommissionMaster.put(eoyMarginTarget.Commission_Master__c,new Map<String,Decimal>{eoyMarginTarget.Type__c => eoyMarginTarget.Target__c});
            }
        }
        
        for(String profile : monthlyCommissionByEOYSalesByProfile.keyset()){            
            if(profile.equalsIgnoreCase(commissionCalculatorconstants.REPTYPEAD)){
                eoySalesCommissionToBeUpdated.addAll(EOYSalesCommissionHandler.eOYSalesRepAnD(monthlyCommissionByEOYSalesByProfile.get(profile),eoySalesCommissionByIdByProfile.get(profile),commissionMasterById,
                                                                                              commissionTierByCommissionMaster,targetByTypeByCommissionMaster,eoyGpTargetBonusByCommissionMaster));
            }      
            else if(profile.equalsIgnoreCase(commissionCalculatorconstants.REPTYPEDEALER) || 
                    profile.equalsIgnoreCase(commissionCalculatorconstants.REPTYPECONTRACTOR)){
                        
                    }
        }
        System.debug('eoySalesCommissionToBeUpdated::'+JSON.serializePretty(eoySalesCommissionToBeUpdated));
        if(!eoySalesCommissionToBeUpdated.isEmpty()){
            update eoySalesCommissionToBeUpdated;
        }
    }
    public static void execute(System.SchedulableContext bc){
        
    }
    public void finish(Database.BatchableContext BC){
        
    }  
}