import Foundation
import Observation

@Observable
final class InvestmentViewModel {
    
    var input: InvestmentInput
    var result: InvestmentResult
    
    private let calculator = InvestmentCalculator()
    
    init() {
        let initialInput = InvestmentInput()
        self.input = initialInput
        self.result = calculator.calculate(input: initialInput)
    }
    
    func recalculate() {
        result = calculator.calculate(input: input)
    }
}
