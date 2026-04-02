import SwiftUI

struct DashboardView: View {
    
    let viewModel: InvestmentViewModel
    
    var body: some View {
        
        let monthlyCashflow = viewModel.result.monthlyCashflowAfterTax
        let monthlyCashflowText = AppFormatter.currencyPerMonth(monthlyCashflow)
        
        let netYield = viewModel.result.netYield
        let netYieldText = AppFormatter.percentage(netYield)
        
        let equityReturn = viewModel.result.equityReturnWithoutAppreciation
        let equityReturnText = AppFormatter.percentage(equityReturn)
        
        let grossYieldText = AppFormatter.percentage(viewModel.result.grossYield)
        let rentFactor = viewModel.result.rentFactor
        let rentFactorText = AppFormatter.decimal(rentFactor, fractionDigits: 1)
        
        let investmentSummary = summaryText(
            monthlyCashflow: monthlyCashflow,
            equityReturn: equityReturn,
            netYield: netYield,
            rentFactor: rentFactor
        )
        
        return ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                Text("Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Investment-Fazit")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Text(investmentSummary)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.12))
                )
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Wichtige Kennzahlen")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 16
                    ) {
                        
                        MetricCard(
                            title: "Cashflow",
                            value: monthlyCashflowText,
                            subtitle: "nach Steuern",
                            valueColor: monthlyCashflow >= 0 ? .green : .red
                        )
                        
                        MetricCard(
                            title: "EK-Rendite",
                            value: equityReturnText,
                            valueColor: equityReturn > 0.10 ? .green : .orange
                        )
                        
                        MetricCard(
                            title: "Nettorendite",
                            value: netYieldText,
                            valueColor: netYield > 0.05 ? .green : .orange
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Weitere Kennzahlen")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 16
                    ) {
                        
                        MetricCard(
                            title: "Bruttorendite",
                            value: grossYieldText
                        )
                        
                        MetricCard(
                            title: "Faktor",
                            value: rentFactorText,
                            subtitle: "Kaufpreis / Miete",
                            valueColor: rentFactor < 20 ? .green : .orange
                        )
                    }
                }
            }
            .padding()
        }
    }
    
    private func summaryText(
        monthlyCashflow: Double,
        equityReturn: Double,
        netYield: Double,
        rentFactor: Double
    ) -> String {
        if monthlyCashflow >= 0 && equityReturn > 0.10 && netYield > 0.05 && rentFactor < 20 {
            return "Positiver Cashflow und insgesamt starke Investment-Kennzahlen."
        } else if monthlyCashflow < 0 && equityReturn > 0.10 {
            return "Starke Rendite, aber der laufende Cashflow ist aktuell negativ."
        } else if monthlyCashflow >= 0 && netYield > 0.05 {
            return "Solide laufende Wirtschaftlichkeit mit positivem Cashflow."
        } else if rentFactor >= 20 {
            return "Die Kaufpreisrelation wirkt aktuell eher ambitioniert."
        } else {
            return "Gemischtes Bild: einzelne Kennzahlen sind solide, andere wirken noch ausbaufähig."
        }
    }
}

#Preview {
    DashboardView(viewModel: InvestmentViewModel())
}cd ~/Desktop

