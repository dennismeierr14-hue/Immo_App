import SwiftUI

struct ProjectionView: View {
    
    let viewModel: InvestmentViewModel
    private var projectionViewModel: ProjectionViewModel
    
    @State private var holdingPeriodYears: Double = 10
    @State private var annualAppreciationRate: Double = 0.02
    @State private var annualRentGrowthRate: Double = 0.02
    @State private var annualCostGrowthRate: Double = 0.02
    @State private var sellingCostRate: Double = 0.03
    @State private var taxRate: Double = 0.30
    
    @State private var useExitFactor: Bool = false
    @State private var exitFactor: Double = 18.0
    
    @State private var selectedChartMode: ProjectionChartMode = .equity
    
    init(viewModel: InvestmentViewModel) {
        self.viewModel = viewModel
        self.projectionViewModel = ProjectionViewModel(investmentViewModel: viewModel)
    }
    
    private var projectionInput: ProjectionInput {
        projectionViewModel.makeProjectionInput(
            holdingPeriodYears: holdingPeriodYears,
            annualAppreciationRate: annualAppreciationRate,
            annualRentGrowthRate: annualRentGrowthRate,
            annualCostGrowthRate: annualCostGrowthRate,
            sellingCostRate: sellingCostRate,
            taxRate: taxRate,
            useExitFactor: useExitFactor,
            exitFactor: exitFactor
        )
    }
    
    private var projectionResult: ProjectionResult {
        projectionViewModel.calculateProjection(for: projectionInput)
    }
    
    private var scenarioEvaluations: [ProjectionScenarioEvaluation] {
        projectionViewModel.evaluateScenarios(from: projectionInput)
    }
    
    private var breakEvenText: String {
        projectionViewModel.breakEvenText(for: projectionResult)
    }
    
    private var breakEvenColor: Color {
        projectionResult.breakEvenYear != nil ? .green : .orange
    }
    
    private var summaryText: String {
        projectionViewModel.summaryText(for: projectionResult)
    }
    
    private var statusTitle: String {
        projectionViewModel.statusTitle(for: projectionResult)
    }
    
    private var statusColor: Color {
        let gain = projectionResult.equityGainAfterTax
        let wealth = projectionResult.totalEquityValueAfterTax
        let initialEquity = viewModel.input.equity
        
        if gain > 0 {
            return .green
        } else if wealth >= initialEquity {
            return .orange
        } else {
            return .red
        }
    }
    
    private var exitMethodText: String {
        useExitFactor ? "Exit über Faktor" : "Exit über Wertsteigerung"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                inputSection
                highlightSection
                resultSection
                chartSection
                timelineSection
                scenarioSection
                summarySection
            }
            .padding()
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Zukunft")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Simulation von Vermögensentwicklung, Exit und kumuliertem Cashflow.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
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
                    title: "Kostensteigerung p.a.",
                    valueText: AppFormatter.percentage(annualCostGrowthRate),
                    value: $annualCostGrowthRate,
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
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Exit-Methode")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text(exitMethodText)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Toggle(isOn: $useExitFactor) {
                        Text("Exit über Faktor statt Wertsteigerung")
                            .font(.subheadline)
                    }
                }
                
                if useExitFactor {
                    sliderRow(
                        title: "Exit-Faktor",
                        valueText: AppFormatter.decimal(exitFactor, fractionDigits: 1),
                        value: $exitFactor,
                        range: 8...30,
                        step: 0.5
                    )
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.12))
            )
        }
    }
    
    private var highlightSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Kurzbewertung")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(statusTitle)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(statusColor)
                    
                    Spacer()
                    
                    Text(breakEvenText)
                        .font(.subheadline)
                        .foregroundStyle(breakEvenColor)
                }
                
                Text("Die Bewertung basiert auf Vermögenszuwachs, Exit-Erlös und kumuliertem Cashflow nach Steuern.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
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
                    title: "Exit-Methode",
                    value: projectionResult.exitMethodLabel
                )
                
                MetricCard(
                    title: "Objektwert",
                    value: AppFormatter.currency(projectionResult.projectedPropertyValue),
                    subtitle: "am Ende der Haltedauer"
                )
                
                MetricCard(
                    title: "Restschuld",
                    value: AppFormatter.currency(projectionResult.projectedLoanBalance),
                    subtitle: "am Exit"
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
                    title: "Cashflow letztes Jahr",
                    value: AppFormatter.currency(projectionResult.annualCashflowAfterTaxAtExit),
                    subtitle: "nach Steuern",
                    valueColor: projectionResult.annualCashflowAfterTaxAtExit >= 0 ? .green : .red
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
                
                MetricCard(
                    title: "Miete am Exit",
                    value: AppFormatter.currency(projectionResult.annualRentAtExit),
                    subtitle: "pro Jahr"
                )
                
                MetricCard(
                    title: "Break-even",
                    value: breakEvenText,
                    subtitle: "erstes positives Jahr",
                    valueColor: breakEvenColor
                )
            }
        }
    }
    
    private var chartSection: some View {
        ProjectionMetricChart(
            entries: projectionResult.yearlyEntries,
            initialEquity: viewModel.input.equity,
            selectedMode: $selectedChartMode
        )
    }
    
    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Jährliche Entwicklung")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            VStack(spacing: 12) {
                ForEach(projectionResult.yearlyEntries) { entry in
                    timelineRow(for: entry)
                }
            }
        }
    }
    
    private var scenarioSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Szenariovergleich")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            VStack(spacing: 12) {
                ForEach(scenarioEvaluations) { evaluation in
                    scenarioRow(for: evaluation)
                }
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
    
    private func timelineRow(for entry: ProjectionYearEntry) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Jahr \(entry.year)")
                    .font(.headline)
                
                Spacer()
                
                Text(AppFormatter.currency(entry.equityValueAfterTax))
                    .font(.headline)
                    .foregroundStyle(entry.equityValueAfterTax >= viewModel.input.equity ? .green : .orange)
            }
            
            HStack {
                Text("Cashflow: \(AppFormatter.currency(entry.annualCashflowAfterTax))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("Restschuld: \(AppFormatter.currency(entry.remainingLoanBalance))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.gray.opacity(0.10))
        )
    }
    
    private func scenarioRow(for evaluation: ProjectionScenarioEvaluation) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(evaluation.title)
                    .font(.headline)
                
                Spacer()
                
                Text(AppFormatter.currency(evaluation.result.equityGainAfterTax))
                    .font(.headline)
                    .foregroundStyle(evaluation.result.equityGainAfterTax >= 0 ? .green : .red)
            }
            
            HStack {
                Text("Δ Gewinn zur Basis: \(AppFormatter.currency(evaluation.equityGainDeltaToBase))")
                    .font(.subheadline)
                    .foregroundStyle(evaluation.equityGainDeltaToBase >= 0 ? .green : .secondary)
                
                Spacer()
                
                Text("Break-even: \(evaluation.result.breakEvenYear != nil ? "\(evaluation.result.breakEvenYear!) J." : "—")")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Text("Vermögen: \(AppFormatter.currency(evaluation.result.totalEquityValueAfterTax)) · Δ Vermögen: \(AppFormatter.currency(evaluation.totalEquityDeltaToBase))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.gray.opacity(0.10))
        )
    }
}

#Preview {
    ProjectionView(viewModel: InvestmentViewModel())
}
