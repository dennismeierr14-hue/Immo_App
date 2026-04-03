import SwiftUI
import Charts

struct ProjectionEquityChart: View {
    
    let entries: [ProjectionYearEntry]
    let initialEquity: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Vermögensverlauf")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Chart {
                ForEach(entries) { entry in
                    LineMark(
                        x: .value("Jahr", entry.year),
                        y: .value("Vermögen", entry.equityValueAfterTax)
                    )
                    
                    AreaMark(
                        x: .value("Jahr", entry.year),
                        y: .value("Vermögen", entry.equityValueAfterTax)
                    )
                    .foregroundStyle(.blue.opacity(0.12))
                }
                
                RuleMark(
                    y: .value("Eigenkapital", initialEquity)
                )
                .foregroundStyle(.orange)
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
            }
            .frame(height: 220)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.12))
        )
    }
}
