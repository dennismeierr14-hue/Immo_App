import Foundation

struct ProjectionScenarioEvaluation: Identifiable {
    let id = UUID()
    let title: String
    let result: ProjectionResult
    let equityGainDeltaToBase: Double
    let totalEquityDeltaToBase: Double
}

struct ProjectionScenarioEvaluator {
    
    static func evaluate(
        scenarios: [ProjectionScenario],
        investmentInput: InvestmentInput,
        investmentResult: InvestmentResult,
        loans: [LoanInput]
    ) -> [ProjectionScenarioEvaluation] {
        
        let rawResults: [(title: String, result: ProjectionResult)] = scenarios.map { scenario in
            (
                title: scenario.title,
                result: ProjectionCalculator.calculate(
                    input: investmentInput,
                    result: investmentResult,
                    projection: scenario.input,
                    loans: loans
                )
            )
        }
        
        let baseResult = rawResults.first(where: { $0.title == "Basis" })?.result
        
        return rawResults.map { item in
            ProjectionScenarioEvaluation(
                title: item.title,
                result: item.result,
                equityGainDeltaToBase: item.result.equityGainAfterTax - (baseResult?.equityGainAfterTax ?? item.result.equityGainAfterTax),
                totalEquityDeltaToBase: item.result.totalEquityValueAfterTax - (baseResult?.totalEquityValueAfterTax ?? item.result.totalEquityValueAfterTax)
            )
        }
    }
}
