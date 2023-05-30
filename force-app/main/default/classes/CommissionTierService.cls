public class CommissionTierService {

    public static Map<Id,Tiers> sepereateCommissionTiers(Map<Id,List<Commission_Tier__c>> commissionTierByCommissionMaster){
        System.debug('Entering:sepereateCommissionTiers => commissionTierByCommissionMaster::'+commissionTierByCommissionMaster);
        Map<Id,Tiers> tiersByCommissionMaster = new Map<Id,Tiers>();
        for(Id commissinMasterId : commissionTierByCommissionMaster.keySet()){
            List<Commission_Tier__c> dealerTiers = new List<Commission_Tier__c>();
            List<Commission_Tier__c> commercialTiers = new List<Commission_Tier__c>();
            for(Commission_Tier__c commissionTier : commissionTierByCommissionMaster.get(commissinMasterId)){
                if(commissionTier.Tier_Type__c.equalsIgnoreCase('Dealer')){
                    dealerTiers.add(commissionTier);
                }
                else if(commissionTier.Tier_Type__c.equalsIgnoreCase('Commercial with Opportunities')){
                    commercialTiers.add(commissionTier);
                }
            }
            if((!dealerTiers.isEmpty()) && (!commercialTiers.isEmpty())){
                tiersByCommissionMaster.put(commissinMasterId,new Tiers(dealerTiers,commercialTiers));
            }
        }
        System.debug('Exit:sepereateCommissionTiers => tiersByCommissionMaster::'+tiersByCommissionMaster);
        return tiersByCommissionMaster;
    }
    
    public static CommissionPercent getCommissionPrecents(Monthly_Commission__c monthlyCommission, Map<Id,Commission_Master__c> commissionMasterById, Map<Id,Tiers> tiersByCommissionMaster){
        
        return new CommissionPercent(CommissionTierUtils.determineCommissionPercent(monthlyCommission.Cumulative_Total_Margin__c, tiersByCommissionMaster.get(monthlyCommission.EoY_Sales_Commission__r.Commission_Master__c).dealerTiers),
                                    CommissionTierUtils.determineCommissionPercent(monthlyCommission.Cumulative_Total_Margin__c, tiersByCommissionMaster.get(monthlyCommission.EoY_Sales_Commission__r.Commission_Master__c).commercialTiers),
                                    commissionMasterById.get(monthlyCommission.EoY_Sales_Commission__r.Commission_Master__c).Commercial_without_Opportunity__c);        

    }

    public static CommissionPercent getCommissionPrecentsViaEoySalesCommission(EoY_Sales_Commission__c eoySalesCommission, Map<Id,Commission_Master__c> commissionMasterById, Map<Id,Tiers> tiersByCommissionMaster){
        
        return new CommissionPercent(CommissionTierUtils.determineCommissionPercent(eoySalesCommission.Total_Margin__c, tiersByCommissionMaster.get(eoySalesCommission.Commission_Master__c).dealerTiers),
                                    CommissionTierUtils.determineCommissionPercent(eoySalesCommission.Total_Margin__c, tiersByCommissionMaster.get(eoySalesCommission.Commission_Master__c).commercialTiers),
                                    commissionMasterById.get(eoySalesCommission.Commission_Master__c).Commercial_without_Opportunity__c);        

    }    

    public class Tiers{
        public List<Commission_Tier__c> dealerTiers = new List<Commission_Tier__c>();
        public List<Commission_Tier__c> commercialTiers = new List<Commission_Tier__c>();
        
        public tiers(List<Commission_Tier__c> dealerTiers, List<Commission_Tier__c> commercialTiers){
            this.dealerTiers = dealerTiers;
            this.commercialTiers = commercialTiers;
        }
    }
    
    public class CommissionPercent{
        public Decimal dealer;
        public Decimal commercialWithOpportunity;
        public Decimal commercialWithoutOpportunity;
        
        public commissionPercent (){
            this.dealer = 0;
            this.commercialWithOpportunity = 0;
            this.commercialWithoutOpportunity = 0;
        }
        
        public commissionPercent(Decimal dealer, Decimal commercialWithOpportunity, Decimal commercialWithoutOpportunity){
            this.dealer = dealer;
            this.commercialWithOpportunity = commercialWithOpportunity;
            this.commercialWithoutOpportunity = commercialWithoutOpportunity;
        }
    }
}