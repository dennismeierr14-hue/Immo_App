import SwiftUI

struct MetricCard: View {
    
    let title: String
    let value: String
    let subtitle: String?
    let valueColor: Color
    
    init(
        title: String,
        value: String,
        subtitle: String? = nil,
        valueColor: Color = .primary
    ) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.valueColor = valueColor
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(valueColor)
            
            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.gray.opacity(0.12))
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        MetricCard(
            title: "Cashflow nach Steuern",
            value: "245 € / Monat",
            subtitle: "inklusive Steuerlogik V1",
            valueColor: .green
        )
        
        MetricCard(
            title: "Bruttorendite",
            value: "5,84 %",
            subtitle: nil
        )
    }
    .padding()
}
