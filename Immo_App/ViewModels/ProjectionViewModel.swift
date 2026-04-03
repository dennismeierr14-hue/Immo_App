import Foundation
import Combine

final class ProjectionViewModel: ObservableObject {
    
    let investmentViewModel: InvestmentViewModel
    
    init(investmentViewModel: InvestmentViewModel) {
        self.investmentViewModel = investmentViewModel
    }
    
    func makeProjectionInput(
        holdingPeriodYears: Double,
        annualAppreciationRate: Double,
        annualRentGrowthRate: Double,
        annualCostGrowthRate: Double,
        sellingCostRate: Double,
        taxRate: Double,
        useExitFactor: Bool,
        exitFactor: Double
    ) -> ProjectionInput {
        ProjectionInput(
            holdingPeriodYears: Int(holdingPeriodYears),
            annualAppreciationRate: annualAppreciationRate,
            annualRentGrowthRate: annualRentGrowthRate,
            annualCostGrowthRate: annualCostGrowthRate,
            sellingCostRate: sellingCostRate,
            taxRate: taxRate,
            useExitFactor: useExitFactor,
            exitFactor: exitFactor
        )
    }
    
    func calculateProjection(for input: ProjectionInput) -> ProjectionResult {
        ProjectionCalculator.calculate(
            input: investmentViewModel.input,
            result: investmentViewModel.result,
            projection: input,
            loans: investmentViewModel.input.loans
        )
    }
    
    func makeScenarios(from input: ProjectionInput) -> [ProjectionScenario] {
        ProjectionScenarioBuilder.makeScenarios(from: input)
    }
    
    func evaluateScenarios(from input: ProjectionInput) -> [ProjectionScenarioEvaluation] {
        let scenarios = makeScenarios(from: input)
        
        return ProjectionScenarioEvaluator.evaluate(
            scenarios: scenarios,
            investmentInput: investmentViewModel.input,
            investmentResult: investmentViewModel.result,
            loans: investmentViewModel.input.loans
        )
    }
    
    func breakEvenText(for result: ProjectionResult) -> String {
        if let year = result.breakEvenYear {
            return "nach \(year) Jahren"
        } else {
            return "nicht erreicht"
        }
    }
    
    func summaryText(for result: ProjectionResult) -> String {
        let gain = result.equityGainAfterTax
        let wealth = result.totalEquityValueAfterTax
        let initialEquity = investmentViewModel.input.equity
        
        if gain > initialEquity {
            return "Sehr starke Entwicklung: Das Investment erzeugt in diesem Szenario einen sehr deutlichen Vermögenszuwachs."
        } else if gain > 0 {
            return "Positive Entwicklung: Nach aktueller Annahme entsteht ein echter Vermögenszuwachs."
        } else if wealth >= initialEquity {
            return "Grenzwertig positiv: Das eingesetzte Eigenkapital wird in etwa gehalten, aber der Mehrwert bleibt begrenzt."
        } else {
            return "Kritisch: In diesem Szenario wird kein ausreichender Vermögenszuwachs erreicht."
        }
    }
    
    func statusTitle(for result: ProjectionResult) -> String {
        let gain = result.equityGainAfterTax
        let wealth = result.totalEquityValueAfterTax
        let initialEquity = investmentViewModel.input.equity
        
        if gain > initialEquity {
            return "Sehr gut"
        } else if gain > 0 {
            return "Positiv"
        } else if wealth >= initialEquity {
            return "Knapp positiv"
        } else {
            return "Kritisch"
        }
    }
}
