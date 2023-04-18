public class CommissionConfigs {
    Map<String, Map<id,mothly_commission__c>> monthlyCommissionByProfileName = new Map<String,Map<id,mothly_commission__c>>();
public void populateMonthlyBreakdownsByMonthlyCommissionByProfile(Set<Id> monthlyCommissions){
        System.debug('Entering:populateMonthlyBreakdownsByMonthlyCommissionByProfile => monthlyCommissions::'+monthlyCommissions); //monthlyCommissionByProfileName
        for(Monthly_Breakdown__c monthlyBreakdown : monthlyBreakDownSelector.getMonthlyBreakDownByMonthlyCommission(monthlyCommissions)){

            if(monthlyCommissionByProfileName.containsKey(monthlyBreakdown.monthly_commission__r.employee__r.profile.name)){

                if((monthlyCommissionByProfileName.get(monthlyBreakdown.monthly_commission__r.employee__r.profile.name).containsKey(monthlyBreakdown.monthly_commission__c)))
                {
                    monthlyCommissionByProfileName.get(monthlyBreakdown.monthly_commission__r.employee__r.profile.name).Tile_Margin__c += monthlyBreakdown.Tile_Margin__c;
                    monthlyCommissionByProfileName.get(monthlyBreakdown.monthly_commission__r.employee__r.profile.name).Ancillary_Margin__c += monthlyBreakdown.Ancillary_Margin__c;
                    
                    monthlyCommissionByProfileName.get(monthlyBreakdown.monthly_commission__r.employee__r.profile.name).Tile_Margin_Percentage__c = (monthlyCommissionByProfileName.get(monthlyBreakdown.monthly_commission__r.employee__r.profile.name).Tile_Margin_Percentage__c+monthlyBreakdown.Tile_Margin_Percentage__c)/100;
                    monthlyCommissionByProfileName.get(monthlyBreakdown.monthly_commission__r.employee__r.profile.name).Ancillary_Margin_Percentage__c = (monthlyCommissionByProfileName.get(monthlyBreakdown.monthly_commission__r.employee__r.profile.name).Ancillary_Margin_Percentage__c+monthlyBreakdown.Ancillary_Margin_Percentage__c)/100;

                    if(monthlyCommissionByProfileName.get(monthlyBreakdown.monthly_commission__r.employee__r.profile.name).Tile_Margin_Percentage__c >= 33.0 && monthlyCommissionByProfileName.get(monthlyBreakdown.monthly_commission__r.employee__r.profile.name).Ancillary_Margin_Percentage__c >= 28.0)
                    {
                        monthlyCommissionByProfileName.get(monthlyBreakdown.monthly_commission__r.employee__r.profile.name).targer_met__c = true;
                    }
                    else {
                        monthlyCommissionByProfileName.get(monthlyBreakdown.monthly_commission__r.employee__r.profile.name).targer_met__c = false;
                    }
                    monthlyCommissionByProfileName.get(monthlyBreakdown.monthly_commission__r.employee__r.profile.name).Eligible_margin__c += monthlyBreakdown.Eligible_Acount__c;
                }
                else {
                    Monthly_Commission__c monthlyCommission = new Monthly_Commission__c();
                    monthlyCommission.id  = monthlyBreakdown.mothly_commission__c;
                    monthlyCommission.Tile_Margin__c = monthlyBreakdown.Tile_Margin__c;
                    monthlyCommission.Ancillary_Margin__c = monthlyBreakdown.Ancillary_Margin__c;
                    monthlyCommission.Tile_Margin_Percentage__c = monthlyBreakdown.Tile_Margin_Percentage__c;
                    monthlyCommission.Ancillary_Margin_Percentage__c = monthlyBreakdown.Ancillary_Margin_Percentage__c;
                    if(monthlyBreakdown.Tile_Margin_Percentage__c >= 33.0 && monthlyBreakdown.Ancillary_Margin_Percentage__c >=28.0)
                    {
                        monthlyCommission.targer_met__c= true;
                    }
                    else {
                        monthlyCommission.targer_met__c= false;
                    }
                    monthlyCommission.Eligible_margin__c = monthlyBreakdown.Eligible_Acount__c;
                    monthlyCommissionByProfileName.get(monthlyBreakdown.monthly_commission__r.employee__r.profile.name).put(monthlyBreakdown.mothly_commission__c , monthlyCommission);
                }


            }
            else {
                Monthly_Commission__c monthlyCommission = new Monthly_Commission__c();
                monthlyCommission.id  = monthlyBreakdown.mothly_commission__c;
                monthlyCommission.Tile_Sale__c = monthlyBreakdown.Tile_Sale__c;
                monthlyCommission.Ancillary_Sale__c = monthlyBreakdown.Ancillary_Sale__c;
                monthlyCommission.Tile_Margin__c = monthlyBreakdown.Tile_Margin__c;
                monthlyCommission.Ancillary_Margin__c = monthlyBreakdown.Ancillary_Margin__c;
                monthlyCommission.Tile_Margin_Percentage__c = monthlyBreakdown.Tile_Margin_Percentage__c;
                monthlyCommission.Ancillary_Margin_Percentage__c = monthlyBreakdown.Ancillary_Margin_Percentage__c;
                if(monthlyBreakdown.Tile_Margin_Percentage__c >= 33.0 && monthlyBreakdown.Ancillary_Margin_Percentage__c >=28.0)
                {
                    monthlyCommission.targer_met__c= true;
                }
                else {
                    monthlyCommission.targer_met__c= false;
                }
                monthlyCommission.Eligible_margin__c = monthlyBreakdown.Eligible_Acount__c;
                monthlyCommissionByProfileName.put(monthlyBreakdown.monthly_commission__r.employee__r.profile.name , new  Map<Id,Monthly_Commission__c> {monthlyBreakdown.monthly_commission__c =>monthlyCommission});
            }

       }
       System.debug('Exit:populateMonthlyBreakdownsByMonthlyCommissionByProfile =>  monthlyBreakdownsByMonthlyCommissionByProfile::'+
                     this.monthlyBreakdownsByMonthlyCommissionByProfile);
    }
}