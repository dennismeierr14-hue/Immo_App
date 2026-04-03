import Foundation

struct ProjectionYearEntry: Identifiable {
    let id = UUID()
    let year: Int
    let annualRent: Double
    let annualCashflowAfterTax: Double
    let remainingLoanBalance: Double
    let propertyValue: Double
    let equityValueAfterTax: Double
}
