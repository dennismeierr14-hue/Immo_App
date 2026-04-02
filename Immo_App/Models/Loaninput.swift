import Foundation

struct LoanInput: Identifiable {
    let id = UUID()
    
    var name: String = "Darlehen"
    var principal: Double = 0
    var interestRate: Double = 0
    var initialRepaymentRate: Double = 0
}
