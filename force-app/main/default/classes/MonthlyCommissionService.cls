public class MonthlyCommissionService {
    public static Monthly_Commission__c  assignMonthlyCommissionViaMonthlyBreakdown(Monthly_Breakdown__c monthlyBreakdown){
        
        Monthly_Commission__c monthlyCommission = new Monthly_Commission__c();
        monthlyCommission.Id  = monthlyBreakdown.Monthly_Commission__c;
        monthlyCommission.Tile_Sale__c = monthlyBreakdown.Tile_Sale__c;
        monthlyCommission.Ancillary_Sale__c = monthlyBreakdown.Ancillary_Sale__c;
        monthlyCommission.Tile_Margin__c = monthlyBreakdown.Tile_Margin__c;
        monthlyCommission.Ancillary_Margin__c = monthlyBreakdown.Ancillary_Margin__c;
        monthlyCommission.Tile_Margin_Percent__c  = monthlyBreakdown.Tile_Margin_Percentage__c;
        monthlyCommission.Ancillary_Margin_Percent__c = monthlyBreakdown.Ancillary_Margin_Percentage__c;
        monthlyCommission.Total_Invoice_Ancillary_Margin__c = monthlyBreakdown.Total_Invoice_Ancillary_Margin__c;
        monthlyCommission.Total_Invoice_Tile_Margin__c = monthlyBreakdown.Total_Invoice_Tile_Margin__c;
        monthlyCommission.Eligible_margin__c = monthlyBreakdown.Elgible_Amount__c;
        return monthlyCommission;
    }

    public static Monthly_Commission__c updateMonthlyCommissionViaMonthlyBreakdown(Monthly_Commission__c monthlyCommission, Monthly_Breakdown__c monthlyBreakdown){
        
    }
}