import Foundation

struct ProjectionInput {
    let holdingPeriodYears: Int
    
    let annualAppreciationRate: Double
    let annualRentGrowthRate: Double
    let annualCostGrowthRate: Double
    
    let sellingCostRate: Double
    let taxRate: Double
    
    let useExitFactor: Bool
    let exitFactor: Double
}
