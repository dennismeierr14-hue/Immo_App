import SwiftUI
import Charts

enum ProjectionChartMode: String, CaseIterable, Identifiable {
    case equity = "Vermögen"
    case cashflow = "Cashflow"
    case loanBalance = "Restschuld"
    
    var id: String { rawValue }
}

struct ProjectionMetricChart: View {
    
    let entries: [ProjectionYearEntry]
    let initialEquity: Double
    @Binding var selectedMode: ProjectionChartMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Verlauf")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Picker("Chart-Modus", selection: $selectedMode) {
                ForEach(ProjectionChartMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            
            Chart {
                ForEach(entries) { entry in
                    LineMark(
                        x: .value("Jahr", entry.year),
                        y: .value(selectedMode.rawValue, value(for: entry))
                    )
                    
                    AreaMark(
                        x: .value("Jahr", entry.year),
                        y: .value(selectedMode.rawValue, value(for: entry))
                    )
                    .foregroundStyle(.blue.opacity(0.12))
                }
                
                if selectedMode == .equity {
                    RuleMark(
                        y: .value("Eigenkapital", initialEquity)
                    )
                    .foregroundStyle(.orange)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                }
            }
            .frame(height: 220)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.12))
        )
    }
    
    private func value(for entry: ProjectionYearEntry) -> Double {
        switch selectedMode {
        case .equity:
            return entry.equityValueAfterTax
        case .cashflow:
            return entry.annualCashflowAfterTax
        case .loanBalance:
            return entry.remainingLoanBalance
        }
    }
}
