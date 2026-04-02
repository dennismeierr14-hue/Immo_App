import SwiftUI

struct ProjectionView: View {
    
    let viewModel: InvestmentViewModel
    
    @State private var holdingPeriodYears: Double = 10
    @State private var annualAppreciationRate: Double = 0.02
    @State private var annualRentGrowthRate: Double = 0.02
    @State private var sellingCostRate: Double = 0.03
    @State private var taxRate: Double = 0.30
    
    private var projectionInput: ProjectionInput {
        ProjectionInput(
            holdingPeriodYears: Int(holdingPeriodYears),
            annualAppreciationRate: annualAppreciationRate,
            annualRentGrowthRate: annualRentGrowthRate,
            sellingCostRate: sellingCostRate,
            taxRate: taxRate
        )
    }
    
    private var projectionResult: ProjectionResult {
        ProjectionCalculator.calculate(
            input: viewModel.input,
            result: viewModel.result,
            projection: projectionInput,
            loans: viewModel.input.loans
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                Text("Zukunft")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                inputSection
                
                resultSection
                
                summarySection
            }
            .padding()
        }
    }
    
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Annahmen")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            VStack(spacing: 16) {
                sliderRow(
                    title: "Haltedauer",
                    valueText: "\(Int(holdingPeriodYears)) Jahre",
                    value: $holdingPeriodYears,
                    range: 1...30,
                    step: 1
                )
                
                sliderRow(
                    title: "Wertsteigerung p.a.",
                    valueText: AppFormatter.percentage(annualAppreciationRate),
                    value: $annualAppreciationRate,
                    range: 0.0...0.06,
                    step: 0.0025
                )
                
                sliderRow(
                    title: "Mietsteigerung p.a.",
                    valueText: AppFormatter.percentage(annualRentGrowthRate),
                    value: $annualRentGrowthRate,
                    range: 0.0...0.05,
                    step: 0.0025
                )
                
                sliderRow(
                    title: "Verkaufskosten",
                    valueText: AppFormatter.percentage(sellingCostRate),
                    value: $sellingCostRate,
                    range: 0.0...0.08,
                    step: 0.0025
                )
                
                sliderRow(
                    title: "Steuersatz",
                    valueText: AppFormatter.percentage(taxRate),
                    value: $taxRate,
                    range: 0.0...0.50,
                    step: 0.01
                )
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.12))
            )
        }
    }
    
    private var resultSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Projektionsergebnis")
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
                    title: "Objektwert",
                    value: AppFormatter.currency(projectionResult.projectedPropertyValue),
                    subtitle: "am Ende der Haltedauer"
                )
                
                MetricCard(
                    title: "Restschuld",
                    value: AppFormatter.currency(projectionResult.projectedLoanBalance),
                    subtitle: "vereinfacht"
                )
                
                MetricCard(
                    title: "Netto-Verkauf",
                    value: AppFormatter.currency(projectionResult.netSaleProceeds),
                    subtitle: "nach Kosten und Darlehen",
                    valueColor: projectionResult.netSaleProceeds >= 0 ? .green : .red
                )
                
                MetricCard(
                    title: "Cashflow kumuliert",
                    value: AppFormatter.currency(projectionResult.cumulativeCashflowAfterTax),
                    subtitle: "nach Steuern",
                    valueColor: projectionResult.cumulativeCashflowAfterTax >= 0 ? .green : .red
                )
                
                MetricCard(
                    title: "Vermögen",
                    value: AppFormatter.currency(projectionResult.totalEquityValueAfterTax),
                    subtitle: "gesamt nach Steuern",
                    valueColor: projectionResult.totalEquityValueAfterTax >= viewModel.input.equity ? .green : .orange
                )
                
                MetricCard(
                    title: "Gewinn",
                    value: AppFormatter.currency(projectionResult.equityGainAfterTax),
                    subtitle: "gegenüber Eigenkapital",
                    valueColor: projectionResult.equityGainAfterTax >= 0 ? .green : .red
                )
            }
        }
    }
    
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Einordnung")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text(summaryText)
                .font(.title3)
                .fontWeight(.semibold)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.12))
        )
    }
    
    private var summaryText: String {
        let gain = projectionResult.equityGainAfterTax
        let wealth = projectionResult.totalEquityValueAfterTax
        let initialEquity = viewModel.input.equity
        
        if gain > initialEquity {
            return "Sehr starke Entwicklung: Das Investment verdoppelt dein eingesetztes Eigenkapital mehr als."
        } else if gain > 0 {
            return "Positive Entwicklung: Nach aktueller Annahme entsteht ein echter Vermögenszuwachs."
        } else if wealth >= initialEquity {
            return "Knapp positiv: Das Investment hält dein Eigenkapital in etwa stabil, aber mit begrenztem Mehrwert."
        } else {
            return "Kritisch: In diesem Szenario wird nach aktueller Annahme kein ausreichender Vermögenszuwachs erreicht."
        }
    }
    
    private func sliderRow(
        title: String,
        valueText: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(valueText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Slider(
                value: value,
                in: range,
                step: step
            )
        }
    }
}

#Preview {
    ProjectionView(viewModel: InvestmentViewModel())
}
