import SwiftUI

struct RentAndReservesView: View {
    
    let viewModel: InvestmentViewModel
    
    private var monthlyRentBinding: Binding<Double> {
        Binding(
            get: { viewModel.input.annualNetColdRent / 12 },
            set: {
                viewModel.input.annualNetColdRent = $0 * 12
                viewModel.recalculate()
            }
        )
    }
    
    private var annualRentBinding: Binding<Double> {
        Binding(
            get: { viewModel.input.annualNetColdRent },
            set: {
                viewModel.input.annualNetColdRent = $0
                viewModel.recalculate()
            }
        )
    }
    
    private var monthlyRentPerSquareMeter: Double {
        guard viewModel.input.livingArea > 0 else { return 0 }
        return (viewModel.input.annualNetColdRent / 12) / viewModel.input.livingArea
    }
    
    private var annualRentPerSquareMeter: Double {
        guard viewModel.input.livingArea > 0 else { return 0 }
        return viewModel.input.annualNetColdRent / viewModel.input.livingArea
    }
    
    var body: some View {
        Form {
            
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Mietübersicht")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    overviewRow(
                        title: "Kaltmiete pro Monat",
                        value: AppFormatter.currency(viewModel.input.annualNetColdRent / 12)
                    )
                    
                    overviewRow(
                        title: "Kaltmiete pro Jahr",
                        value: AppFormatter.currency(viewModel.input.annualNetColdRent)
                    )
                    
                    overviewRow(
                        title: "Miete pro m² / Monat",
                        value: AppFormatter.currency(monthlyRentPerSquareMeter) + " / m²"
                    )
                    
                    overviewRow(
                        title: "Miete pro m² / Jahr",
                        value: AppFormatter.currency(annualRentPerSquareMeter) + " / m²"
                    )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.12))
                )
            }
            
            Section("Miete") {
                TextField("Kaltmiete pro Monat in €", value: monthlyRentBinding, format: .number)
                
                TextField("Kaltmiete pro Jahr in €", value: annualRentBinding, format: .number)
                
                TextField("Sonstige Jahreseinnahmen in €", value: Binding(
                    get: { viewModel.input.annualOtherIncome },
                    set: {
                        viewModel.input.annualOtherIncome = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
            }
            
            Section("Rücklagen") {
                TextField("Leerstandspuffer pro Monat in €", value: Binding(
                    get: { viewModel.input.vacancyAllowance },
                    set: {
                        viewModel.input.vacancyAllowance = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
                
                TextField("Instandhaltungsrücklage pro Monat in €", value: Binding(
                    get: { viewModel.input.maintenanceReserve },
                    set: {
                        viewModel.input.maintenanceReserve = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
            }
        }
        .navigationTitle("Miete & Rücklagen")
    }
    
    private func overviewRow(
        title: String,
        value: String
    ) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    RentAndReservesView(viewModel: InvestmentViewModel())
}
