import Foundation

struct InvestmentResult {
    var totalCapitalRequired: Double
    
    var grossYield: Double
    var rentFactor: Double
    var nonAllocableCostsPerYear: Double
    var netYield: Double
    
    var weightedInterestRate: Double
    var weightedRepaymentRate: Double
    
    var monthlyInterest: Double
    var monthlyRepayment: Double
    var monthlyDebtService: Double
    
    var monthlyOperationalCashflow: Double
    var monthlyTaxableCashflow: Double
    var monthlyTaxes: Double
    var monthlyCashflowAfterTax: Double
    
    var equityReturnWithoutAppreciation: Double
}
