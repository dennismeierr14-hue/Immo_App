import Foundation

struct ProjectionResult {
    let holdingPeriodYears: Int
    let annualRentAtExit: Double
    let annualNetOperatingIncomeAtExit: Double
    let projectedPropertyValue: Double
    let projectedSaleCosts: Double
    let projectedLoanBalance: Double
    let netSaleProceeds: Double
    let cumulativeCashflowBeforeTax: Double
    let cumulativeCashflowAfterTax: Double
    let totalEquityValueBeforeTax: Double
    let totalEquityValueAfterTax: Double
    let equityGainBeforeTax: Double
    let equityGainAfterTax: Double
    let breakEvenYear: Int?
}
