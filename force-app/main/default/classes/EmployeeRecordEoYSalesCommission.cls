public class EmployeeRecordEoYSalesCommission  implements Database.Batchable<sObject>{
     /*******
     This method will query all the active user on the profile bases 
     ********/
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String profileName = commissionCalculatorconstants.salesRepADProfile; 
        String userListOnProfileBasis = 'Select Id,Name from User where User.Profile.Name='+'profileName'+' AND IsActive=true AND Dont_calculate_commission__c = false';
        return Database.getQueryLocator(userListOnProfileBasis);
    }
    public void execute(Database.BatchableContext BC, list<User> userListOnProfileBasis){
        List<EoY_Sales_Commission__c> listEoYSalesCommission = new List<EoY_Sales_Commission__c>();
        Id recordTypeId = Schema.SObjectType.Commission_Master__c.getRecordTypeInfosByName().get('Sales Rep A&D').getRecordTypeId();
        String commissionMaster = CommissionMasterSelector.getCommissionMasterRecordTypeBases(recordTypeId);
        for(User user : userListOnProfileBasis){
            EoY_Sales_Commission__c salesCommissionEoY = new EoY_Sales_Commission__c();
            salesCommissionEoY.Employee__c = user.Name;
            salesCommissionEoY.Commission_Master__c = commissionMaster;
            listEoYSalesCommission.add(salesCommissionEoY);
        }
        try {
            insert listEoYSalesCommission;
        } 
        catch(DmlException e) {
            ExceptionUtils.createExceptionLogV2('EoY_Sales_Commission__c',e.getMessage(),e.getStackTraceString());
        }
    }
    public void finish(Database.BatchableContext BC){
        
    }
}