import SwiftUI

struct CostInputView: View {
    
    let viewModel: InvestmentViewModel
    
    var body: some View {
        
        let nonAllocablePerMonth =
            viewModel.input.nonAllocableHouseFee +
            viewModel.input.vacancyAllowance +
            viewModel.input.maintenanceReserve +
            viewModel.input.otherNonAllocableCosts
        
        let nonAllocablePerYear = nonAllocablePerMonth * 12
        let monthlyIncome = (viewModel.input.annualNetColdRent + viewModel.input.annualOtherIncome) / 12
        let monthlySurplusBeforeDebtService = monthlyIncome - nonAllocablePerMonth
        
        let nonAllocablePerMonthText = AppFormatter.currencyPerMonth(nonAllocablePerMonth)
        let nonAllocablePerYearText = AppFormatter.currency(nonAllocablePerYear)
        let monthlySurplusBeforeDebtServiceText = AppFormatter.currencyPerMonth(monthlySurplusBeforeDebtService)
        
        return Form {
            
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Kostenübersicht")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        Text("Nicht umlagefähig / Monat")
                        Spacer()
                        Text(nonAllocablePerMonthText)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Nicht umlagefähig / Jahr")
                        Spacer()
                        Text(nonAllocablePerYearText)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Überschuss vor Kapitaldienst")
                        Spacer()
                        Text(monthlySurplusBeforeDebtServiceText)
                            .fontWeight(.semibold)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.12))
                )
            }
            
            Section("Hausgeld und laufende Kosten") {
                TextField("Hausgeld umlagefähig pro Monat in €", value: Binding(
                    get: { viewModel.input.allocableHouseFee },
                    set: {
                        viewModel.input.allocableHouseFee = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
                
                TextField("Hausgeld nicht umlagefähig pro Monat in €", value: Binding(
                    get: { viewModel.input.nonAllocableHouseFee },
                    set: {
                        viewModel.input.nonAllocableHouseFee = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
                
                TextField("Grundsteuer pro Monat in €", value: Binding(
                    get: { viewModel.input.propertyTax },
                    set: {
                        viewModel.input.propertyTax = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
                
                TextField("Sonstige umlagefähige Kosten pro Monat in €", value: Binding(
                    get: { viewModel.input.otherAllocableCosts },
                    set: {
                        viewModel.input.otherAllocableCosts = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
            }
            
            Section("Risiko und Rücklagen") {
                TextField("Kalkulatorischer Mietausfall pro Monat in €", value: Binding(
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
                
                TextField("Sonstige nicht umlagefähige Kosten pro Monat in €", value: Binding(
                    get: { viewModel.input.otherNonAllocableCosts },
                    set: {
                        viewModel.input.otherNonAllocableCosts = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
            }
        }
        .navigationTitle("Kosten")
    }
}

#Preview {
    CostInputView(viewModel: InvestmentViewModel())
}
