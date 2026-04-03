import SwiftUI

struct PropertyInputView: View {
    
    let viewModel: InvestmentViewModel
    
    private var notaryCosts: Double {
        viewModel.input.purchasePrice * viewModel.input.notaryRate
    }
    
    private var landRegistryCosts: Double {
        viewModel.input.purchasePrice * viewModel.input.landRegistryRate
    }
    
    private var realEstateTransferTax: Double {
        viewModel.input.purchasePrice * viewModel.input.realEstateTransferTaxRate
    }
    
    private var brokerCommission: Double {
        viewModel.input.purchasePrice * viewModel.input.brokerCommissionRate
    }
    
    private var additionalPurchaseCosts: Double {
        notaryCosts + landRegistryCosts + realEstateTransferTax + brokerCommission
    }
    
    private var depreciationBase: Double {
        viewModel.input.purchasePrice * viewModel.input.buildingValueShare
    }
    
    private var annualDepreciation: Double {
        depreciationBase * viewModel.input.depreciationRate
    }
    
    private var purchasePricePerSquareMeter: Double {
        viewModel.input.livingArea > 0
            ? viewModel.input.purchasePrice / viewModel.input.livingArea
            : 0
    }
    
    var body: some View {
        
        let totalCapitalRequired = viewModel.result.totalCapitalRequired
        
        return Form {
            
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Objektübersicht")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    overviewRow(
                        title: "Kaufpreis",
                        value: AppFormatter.currency(viewModel.input.purchasePrice)
                    )
                    
                    overviewRow(
                        title: "Kaufnebenkosten",
                        value: AppFormatter.currency(additionalPurchaseCosts)
                    )
                    
                    overviewRow(
                        title: "Gesamtkapitalbedarf",
                        value: AppFormatter.currency(totalCapitalRequired),
                        emphasized: true
                    )
                    
                    overviewRow(
                        title: "Kaufpreis pro m²",
                        value: AppFormatter.currency(purchasePricePerSquareMeter) + " / m²"
                    )
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
                
                TextField("Kaufpreis in €", value: Binding(
                    get: { viewModel.input.purchasePrice },
                    set: {
                        viewModel.input.purchasePrice = $0
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
            }
            
            Section("Nebenkostensätze") {
                TextField("Notar", value: Binding(
                    get: { viewModel.input.notaryRate },
                    set: {
                        viewModel.input.notaryRate = $0
                        viewModel.recalculate()
                    }
                ), format: .percent)
                
                TextField("Grundbuchamt", value: Binding(
                    get: { viewModel.input.landRegistryRate },
                    set: {
                        viewModel.input.landRegistryRate = $0
                        viewModel.recalculate()
                    }
                ), format: .percent)
                
                TextField("Grunderwerbsteuer", value: Binding(
                    get: { viewModel.input.realEstateTransferTaxRate },
                    set: {
                        viewModel.input.realEstateTransferTaxRate = $0
                        viewModel.recalculate()
                    }
                ), format: .percent)
                
                TextField("Maklercourtage", value: Binding(
                    get: { viewModel.input.brokerCommissionRate },
                    set: {
                        viewModel.input.brokerCommissionRate = $0
                        viewModel.recalculate()
                    }
                ), format: .percent)
            }
            
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Kaufnebenkosten")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    overviewRow(
                        title: "Notar",
                        value: AppFormatter.currency(notaryCosts)
                    )
                    
                    overviewRow(
                        title: "Grundbuchamt",
                        value: AppFormatter.currency(landRegistryCosts)
                    )
                    
                    overviewRow(
                        title: "Grunderwerbsteuer",
                        value: AppFormatter.currency(realEstateTransferTax)
                    )
                    
                    overviewRow(
                        title: "Maklercourtage",
                        value: AppFormatter.currency(brokerCommission)
                    )
                    
                    Divider()
                    
                    overviewRow(
                        title: "Nebenkosten gesamt",
                        value: AppFormatter.currency(additionalPurchaseCosts),
                        emphasized: true
                    )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.12))
                )
            }
            
            Section("AfA") {
                TextField("AfA-Satz", value: Binding(
                    get: { viewModel.input.depreciationRate },
                    set: {
                        viewModel.input.depreciationRate = $0
                        viewModel.recalculate()
                    }
                ), format: .percent)
                
                TextField("Gebäudeanteil am Kaufpreis", value: Binding(
                    get: { viewModel.input.buildingValueShare },
                    set: {
                        viewModel.input.buildingValueShare = $0
                        viewModel.recalculate()
                    }
                ), format: .percent)
            }
            
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("AfA-Berechnung")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    overviewRow(
                        title: "AfA-Basis",
                        value: AppFormatter.currency(depreciationBase)
                    )
                    
                    overviewRow(
                        title: "Jährliche AfA",
                        value: AppFormatter.currency(annualDepreciation),
                        emphasized: true
                    )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.12))
                )
            }
        }
        .navigationTitle("Objekt")
    }
    
    private func overviewRow(
        title: String,
        value: String,
        emphasized: Bool = false
    ) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .fontWeight(emphasized ? .bold : .semibold)
        }
    }
}

#Preview {
    PropertyInputView(viewModel: InvestmentViewModel())
}
