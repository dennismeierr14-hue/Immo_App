import SwiftUI

struct FinancingView: View {
    
    let viewModel: InvestmentViewModel
    
    var body: some View {
        
        let totalDebt = viewModel.input.loans.reduce(0) { $0 + $1.principal }
        let equity = viewModel.input.equity
        let totalCapital = equity + totalDebt
        
        let totalDebtText = AppFormatter.currency(totalDebt)
        let weightedInterestText = AppFormatter.percentage(viewModel.result.weightedInterestRate)
        let monthlyDebtServiceText = AppFormatter.currencyPerMonth(viewModel.result.monthlyDebtService)
        
        let equityShare = totalCapital > 0 ? equity / totalCapital : 0
        let debtShare = totalCapital > 0 ? totalDebt / totalCapital : 0
        
        let equityShareText = AppFormatter.percentage(equityShare)
        let debtShareText = AppFormatter.percentage(debtShare)
        
        return Form {
            
            Section {
                VStack(alignment: .leading, spacing: 14) {
                    
                    Text("Finanzierungsübersicht")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        Text("Gesamtdarlehen")
                        Spacer()
                        Text(totalDebtText)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Ø Zinssatz")
                        Spacer()
                        Text(weightedInterestText)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Kapitaldienst")
                        Spacer()
                        Text(monthlyDebtServiceText)
                            .fontWeight(.semibold)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Kapitalstruktur")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        GeometryReader { geometry in
                            let totalWidth = geometry.size.width
                            let equityWidth = totalWidth * equityShare
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.18))
                                    .frame(height: 14)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.green.opacity(0.75))
                                    .frame(width: equityWidth, height: 14)
                            }
                        }
                        .frame(height: 14)
                        
                        HStack {
                            Text("Eigenkapital: \(equityShareText)")
                            Spacer()
                            Text("Fremdkapital: \(debtShareText)")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.12))
                )
            }
            
            Section("Eigenkapital") {
                TextField("Eigenkapital in €", value: Binding(
                    get: { viewModel.input.equity },
                    set: {
                        viewModel.input.equity = $0
                        viewModel.recalculate()
                    }
                ), format: .number)
            }
            
            ForEach(viewModel.input.loans) { loan in
                LoanSectionView(
                    title: sectionTitle(for: loan.id),
                    loan: binding(for: loan.id),
                    canRemove: canRemoveLoan(with: loan.id),
                    onRemove: {
                        removeLoan(with: loan.id)
                    }
                )
            }
            
            if viewModel.input.loans.count < 4 {
                Section {
                    Button("+ Darlehen hinzufügen") {
                        addLoan()
                    }
                }
            }
        }
        .navigationTitle("Finanzierung")
    }
    
    private func sectionTitle(for loanID: UUID) -> String {
        guard let index = viewModel.input.loans.firstIndex(where: { $0.id == loanID }) else {
            return "Darlehen"
        }
        return "Darlehen \(index + 1)"
    }
    
    private func canRemoveLoan(with loanID: UUID) -> Bool {
        guard let firstLoanID = viewModel.input.loans.first?.id else {
            return false
        }
        return loanID != firstLoanID
    }
    
    private func binding(for loanID: UUID) -> Binding<LoanInput> {
        Binding(
            get: {
                viewModel.input.loans.first(where: { $0.id == loanID }) ?? LoanInput(
                    name: "",
                    principal: 0,
                    interestRate: 0,
                    initialRepaymentRate: 0
                )
            },
            set: { updatedLoan in
                if let index = viewModel.input.loans.firstIndex(where: { $0.id == loanID }) {
                    viewModel.input.loans[index] = updatedLoan
                    viewModel.recalculate()
                }
            }
        )
    }
    
    private func addLoan() {
        let newIndex = viewModel.input.loans.count + 1
        
        viewModel.input.loans.append(
            LoanInput(
                name: "Darlehen \(newIndex)",
                principal: 0,
                interestRate: 0,
                initialRepaymentRate: 0
            )
        )
        
        viewModel.recalculate()
    }
    
    private func removeLoan(with loanID: UUID) {
        viewModel.input.loans.removeAll { $0.id == loanID }
        viewModel.recalculate()
    }
}

private struct LoanSectionView: View {
    
    let title: String
    @Binding var loan: LoanInput
    let canRemove: Bool
    let onRemove: () -> Void
    
    var body: some View {
        Section(title) {
            TextField("Bezeichnung", text: Binding(
                get: { loan.name },
                set: { loan.name = $0 }
            ))
            
            TextField("Darlehensbetrag in €", value: Binding(
                get: { loan.principal },
                set: { loan.principal = $0 }
            ), format: .number)
            
            TextField("Zinssatz in %", value: Binding(
                get: { loan.interestRate },
                set: { loan.interestRate = $0 }
            ), format: .number)
            
            TextField("Anfängliche Tilgung in %", value: Binding(
                get: { loan.initialRepaymentRate },
                set: { loan.initialRepaymentRate = $0 }
            ), format: .number)
            
            if canRemove {
                Button("Darlehen entfernen", role: .destructive) {
                    onRemove()
                }
            }
        }
    }
}

#Preview {
    FinancingView(viewModel: InvestmentViewModel())
}
