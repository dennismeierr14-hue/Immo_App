import Foundation

struct ProjectionScenarioBuilder {
    
    static func makeScenarios(from base: ProjectionInput) -> [ProjectionScenario] {
        let conservative = ProjectionScenario(
            title: "Konservativ",
            input: ProjectionInput(
                holdingPeriodYears: base.holdingPeriodYears,
                annualAppreciationRate: max(base.annualAppreciationRate - 0.01, 0.0),
                annualRentGrowthRate: max(base.annualRentGrowthRate - 0.01, 0.0),
                annualCostGrowthRate: base.annualCostGrowthRate + 0.01,
                sellingCostRate: base.sellingCostRate + 0.01,
                taxRate: base.taxRate,
                useExitFactor: base.useExitFactor,
                exitFactor: max(base.exitFactor + 2.0, 1.0)
            )
        )
        
        let baseScenario = ProjectionScenario(
            title: "Basis",
            input: base
        )
        
        let optimistic = ProjectionScenario(
            title: "Optimistisch",
            input: ProjectionInput(
                holdingPeriodYears: base.holdingPeriodYears,
                annualAppreciationRate: base.annualAppreciationRate + 0.01,
                annualRentGrowthRate: base.annualRentGrowthRate + 0.01,
                annualCostGrowthRate: max(base.annualCostGrowthRate - 0.01, 0.0),
                sellingCostRate: max(base.sellingCostRate - 0.01, 0.0),
                taxRate: base.taxRate,
                useExitFactor: base.useExitFactor,
                exitFactor: max(base.exitFactor - 2.0, 1.0)
            )
        )
        
        return [conservative, baseScenario, optimistic]
    }
}
