import Foundation

enum AppFormatter {
    
    private static func decimalFormatter(fractionDigits: Int = 0) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "de_DE")
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter
    }
    
    static func currency(_ value: Double) -> String {
        let formatter = decimalFormatter()
        let formatted = formatter.string(from: NSNumber(value: value)) ?? "0"
        return "\(formatted) €"
    }
    
    static func currencyPerMonth(_ value: Double) -> String {
        let formatter = decimalFormatter()
        let formatted = formatter.string(from: NSNumber(value: value)) ?? "0"
        return "\(formatted) € / Monat"
    }
    
    static func percentage(_ value: Double) -> String {
        let formatter = decimalFormatter(fractionDigits: 2)
        let formatted = formatter.string(from: NSNumber(value: value * 100)) ?? "0,00"
        return "\(formatted) %"
    }
    
    static func decimal(_ value: Double, fractionDigits: Int = 1) -> String {
        let formatter = decimalFormatter(fractionDigits: fractionDigits)
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }
}   
