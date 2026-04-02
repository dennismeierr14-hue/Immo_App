import Foundation

struct InvestmentInput {
    
    // MARK: - Objekt
    
    var objectName: String = "Mein Investment"
    
    var purchasePrice: Double = 3_000_000
    var additionalPurchaseCosts: Double = 0
    var livingArea: Double = 2300
    
    var annualNetColdRent: Double = 204_996
    var annualOtherIncome: Double = 0
    
    var holdingPeriodYears: Int = 10
    
    // MARK: - Kosten (monatlich)
    
    var allocableHouseFee: Double = 0
    var nonAllocableHouseFee: Double = 0
    var propertyTax: Double = 0
    var otherAllocableCosts: Double = 0
    
    var vacancyAllowance: Double = 342
    var maintenanceReserve: Double = 2_484
    var otherNonAllocableCosts: Double = 0
    
    // MARK: - Finanzierung
    
    var equity: Double = 210_000
    
    var loans: [LoanInput] = [
        LoanInput(
            name: "Darlehen 1",
            principal: 3_000_000,
            interestRate: 0.042,
            initialRepaymentRate: 0.015
        )
    ]
    
    // MARK: - Steuern & Zukunft
    
    var personalTaxRate: Double = 0.42
    var annualDepreciation: Double = 96_300
    
    var annualRentGrowthRate: Double = 0.02
    var annualValueGrowthRate: Double = 0.02
    
    var exitFactor: Double = 15.0
    var interestShock: Double = 0.015
}
