import Foundation
import Combine

final class InvestmentViewModel: ObservableObject {
    
    @Published var input: InvestmentInput
    @Published var result: InvestmentResult
    
    private let calculator = InvestmentCalculator()
    
    init(input: InvestmentInput = InvestmentInput()) {
        self.input = input
        self.result = calculator.calculate(input: input)
    }
    
    func recalculate() {
        result = calculator.calculate(input: input)
    }
}
