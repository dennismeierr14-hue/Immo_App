import SwiftUI

struct ProjectionView: View {
    
    let viewModel: InvestmentViewModel
    
    var body: some View {
        Form {
            Section("Steuern") {
                TextField("Persönlicher Steuersatz in %", value: Binding(
                    get: { viewModel.input.personalTaxRate },
                    set: {
                        viewModel.input.personalTaxRate = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
                
                TextField("AfA pro Jahr in €", value: Binding(
                    get: { viewModel.input.annualDepreciation },
                    set: {
                        viewModel.input.annualDepreciation = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
            }
            
            Section("Wachstum") {
                TextField("Mietwachstum pro Jahr in %", value: Binding(
                    get: { viewModel.input.annualRentGrowthRate },
                    set: {
                        viewModel.input.annualRentGrowthRate = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
                
                TextField("Wertsteigerung pro Jahr in %", value: Binding(
                    get: { viewModel.input.annualValueGrowthRate },
                    set: {
                        viewModel.input.annualValueGrowthRate = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
            }
            
            Section("Exit und Risiko") {
                TextField("Exit-Faktor", value: Binding(
                    get: { viewModel.input.exitFactor },
                    set: {
                        viewModel.input.exitFactor = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
                
                TextField("Zinsschock in %", value: Binding(
                    get: { viewModel.input.interestShock },
                    set: {
                        viewModel.input.interestShock = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
            }
        }
        .navigationTitle("Zukunft")
    }
}

#Preview {
    ProjectionView(viewModel: InvestmentViewModel())
}
