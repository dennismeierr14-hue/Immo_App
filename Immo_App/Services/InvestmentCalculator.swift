import Foundation

final class InvestmentCalculator {
    
    func calculate(input: InvestmentInput) -> InvestmentResult {
        
        // Gesamtkapital
        let totalCapitalRequired = input.purchasePrice + input.additionalPurchaseCosts
        
        // Rendite & Faktor
        let annualRent = input.annualNetColdRent
        let grossYield = totalCapitalRequired > 0 ? annualRent / totalCapitalRequired : 0
        let rentFactor = annualRent > 0 ? totalCapitalRequired / annualRent : 0
        
        // Nicht umlagefähige Kosten
        let nonAllocableCostsPerMonth =
            input.nonAllocableHouseFee +
            input.vacancyAllowance +
            input.maintenanceReserve +
            input.otherNonAllocableCosts
        
        let nonAllocableCostsPerYear = nonAllocableCostsPerMonth * 12
        
        let netYield = totalCapitalRequired > 0
            ? (annualRent - nonAllocableCostsPerYear) / totalCapitalRequired
            : 0
        
        // Finanzierung
        let totalLoanAmount = input.loans.reduce(0) { $0 + $1.principal }
        
        let weightedInterestRate = totalLoanAmount > 0
            ? input.loans.reduce(0) { $0 + ($1.principal * $1.interestRate) } / totalLoanAmount
            : 0
        
        let weightedRepaymentRate = totalLoanAmount > 0
            ? input.loans.reduce(0) { $0 + ($1.principal * $1.initialRepaymentRate) } / totalLoanAmount
            : 0
        
        let monthlyInterest = input.loans.reduce(0) {
            $0 + ($1.principal * $1.interestRate / 12)
        }
        
        let monthlyRepayment = input.loans.reduce(0) {
            $0 + ($1.principal * $1.initialRepaymentRate / 12)
        }
        
        let monthlyDebtService = monthlyInterest + monthlyRepayment
        
        // Einnahmen
        let monthlyIncome = (input.annualNetColdRent + input.annualOtherIncome) / 12
        
        // Cashflow operativ
        let monthlyOperationalCashflow =
            monthlyIncome
            - nonAllocableCostsPerMonth
            - monthlyInterest
            - monthlyRepayment
        
        // Steuern
        let monthlyDepreciation = input.annualDepreciation / 12
        
        let monthlyTaxableCashflow =
            monthlyIncome
            - nonAllocableCostsPerMonth
            - monthlyInterest
            - monthlyDepreciation
        
        let monthlyTaxes = monthlyTaxableCashflow > 0
            ? monthlyTaxableCashflow * input.personalTaxRate
            : 0
        
        let monthlyCashflowAfterTax = monthlyOperationalCashflow - monthlyTaxes
        
        // EK-Rendite
        let annualCashflowAfterTax = monthlyCashflowAfterTax * 12
        let annualRepayment = monthlyRepayment * 12
        
        let equityReturnWithoutAppreciation = input.equity > 0
            ? (annualCashflowAfterTax + annualRepayment) / input.equity
            : 0
        
        return InvestmentResult(
            totalCapitalRequired: totalCapitalRequired,
            grossYield: grossYield,
            rentFactor: rentFactor,
            nonAllocableCostsPerYear: nonAllocableCostsPerYear,
            netYield: netYield,
            weightedInterestRate: weightedInterestRate,
            weightedRepaymentRate: weightedRepaymentRate,
            monthlyInterest: monthlyInterest,
            monthlyRepayment: monthlyRepayment,
            monthlyDebtService: monthlyDebtService,
            monthlyOperationalCashflow: monthlyOperationalCashflow,
            monthlyTaxableCashflow: monthlyTaxableCashflow,
            monthlyTaxes: monthlyTaxes,
            monthlyCashflowAfterTax: monthlyCashflowAfterTax,
            equityReturnWithoutAppreciation: equityReturnWithoutAppreciation
        )
    }
}
