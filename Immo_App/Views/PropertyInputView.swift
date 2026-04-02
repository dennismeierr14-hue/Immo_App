import SwiftUI

struct PropertyInputView: View {
    
    let viewModel: InvestmentViewModel
    
    var body: some View {
        
        let totalCapitalRequired = viewModel.result.totalCapitalRequired
        let annualRent = viewModel.input.annualNetColdRent
        let purchasePricePerSquareMeter = viewModel.input.livingArea > 0
            ? viewModel.input.purchasePrice / viewModel.input.livingArea
            : 0
        
        let totalCapitalText = AppFormatter.currency(totalCapitalRequired)
        let annualRentText = AppFormatter.currency(annualRent)
        let pricePerSquareMeterText = AppFormatter.currency(purchasePricePerSquareMeter) + " / m²"
        
        return Form {
            
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Objektübersicht")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        Text("Gesamtkapitalbedarf")
                        Spacer()
                        Text(totalCapitalText)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Jahresnettokaltmiete")
                        Spacer()
                        Text(annualRentText)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Kaufpreis pro m²")
                        Spacer()
                        Text(pricePerSquareMeterText)
                            .fontWeight(.semibold)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.12))
                )
            }
            
            Section("Objektbasisdaten") {
                TextField("Objektname", text: Binding(
                    get: { viewModel.input.objectName },
                    set: {
                        viewModel.input.objectName = $0
                        viewModel.recalculate()
                    }
                ))
            }
            
            Section("Kauf und Ertrag") {
                TextField("Kaufpreis in €", value: Binding(
                    get: { viewModel.input.purchasePrice },
                    set: {
                        viewModel.input.purchasePrice = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
                
                TextField("Kaufnebenkosten in €", value: Binding(
                    get: { viewModel.input.additionalPurchaseCosts },
                    set: {
                        viewModel.input.additionalPurchaseCosts = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
                
                TextField("Wohnfläche in m²", value: Binding(
                    get: { viewModel.input.livingArea },
                    set: {
                        viewModel.input.livingArea = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
                
                TextField("Jahresnettokaltmiete in €", value: Binding(
                    get: { viewModel.input.annualNetColdRent },
                    set: {
                        viewModel.input.annualNetColdRent = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
            }
        }
        .navigationTitle("Objekt")
    }
}

#Preview {
    PropertyInputView(viewModel: InvestmentViewModel())
}
