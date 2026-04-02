import Foundation

struct ProjectionCalculator {
    
    static func calculate(
        input: InvestmentInput,
        result: InvestmentResult,
        projection: ProjectionInput,
        loans: [LoanInput]
    ) -> ProjectionResult {
        
        let years = projection.holdingPeriodYears
        
        // MARK: Property Value Growth
        
        let projectedValue = input.purchasePrice *
        pow(1 + projection.annualAppreciationRate, Double(years))
        
        // MARK: Rent Growth
        
        let annualRent = input.annualNetColdRent + input.annualOtherIncome
        
        let projectedRent = annualRent *
        pow(1 + projection.annualRentGrowthRate, Double(years))
        
        // MARK: NOI
        
        let projectedNOI = projectedRent - result.nonAllocableCostsPerYear
        
        // MARK: Loan Balance (vereinfachte Annahme)
        
        let totalLoan = loans
            .map { $0.principal }
            .reduce(0, +)
        
        let annualRepayment = loans
            .map { $0.principal * $0.initialRepaymentRate }
            .reduce(0, +)
        
        let remainingLoan = max(
            totalLoan - (annualRepayment * Double(years)),
            0
        )
        
        // MARK: Sale
        
        let saleCosts = projectedValue * projection.sellingCostRate
        
        let netSale = projectedValue - saleCosts - remainingLoan
        
        // MARK: Cashflow
        
        let annualCashflowBeforeTax =
        result.monthlyOperationalCashflow * 12
        
        let cumulativeCashflowBeforeTax =
        annualCashflowBeforeTax * Double(years)
        
        let cumulativeCashflowAfterTax =
        cumulativeCashflowBeforeTax * (1 - projection.taxRate)
        
        // MARK: Equity
        
        let equityBeforeTax = netSale + cumulativeCashflowBeforeTax
        
        let equityAfterTax = netSale + cumulativeCashflowAfterTax
        
        let equityGainBeforeTax =
        equityBeforeTax - input.equity
        
        let equityGainAfterTax =
        equityAfterTax - input.equity
        
        // MARK: Break-even
        
        let breakEvenYear: Int? =
        equityGainAfterTax > 0 ? years : nil
        
        return ProjectionResult(
            holdingPeriodYears: years,
            annualRentAtExit: projectedRent,
            annualNetOperatingIncomeAtExit: projectedNOI,
            projectedPropertyValue: projectedValue,
            projectedSaleCosts: saleCosts,
            projectedLoanBalance: remainingLoan,
            netSaleProceeds: netSale,
            cumulativeCashflowBeforeTax: cumulativeCashflowBeforeTax,
            cumulativeCashflowAfterTax: cumulativeCashflowAfterTax,
            totalEquityValueBeforeTax: equityBeforeTax,
            totalEquityValueAfterTax: equityAfterTax,
            equityGainBeforeTax: equityGainBeforeTax,
            equityGainAfterTax: equityGainAfterTax,
            breakEvenYear: breakEvenYear
        )
    }
}
