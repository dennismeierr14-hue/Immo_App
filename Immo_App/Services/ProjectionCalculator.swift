import Foundation

struct ProjectionCalculator {
    
    static func calculate(
        input: InvestmentInput,
        result: InvestmentResult,
        projection: ProjectionInput,
        loans: [LoanInput]
    ) -> ProjectionResult {
        
        let years = projection.holdingPeriodYears
        
        let annualRentStart = input.annualNetColdRent + input.annualOtherIncome
        let baseNonAllocableCosts = result.nonAllocableCostsPerYear
        
        var remainingLoans = loans.map { $0.principal }
        
        var cumulativeCashflowBeforeTax: Double = 0
        var cumulativeCashflowAfterTax: Double = 0
        var breakEvenYear: Int? = nil
        
        var annualCashflowBeforeTaxAtExit: Double = 0
        var annualCashflowAfterTaxAtExit: Double = 0
        
        var yearlyEntries: [ProjectionYearEntry] = []
        
        for year in 1...years {
            
            let rentGrowthFactor = pow(1 + projection.annualRentGrowthRate, Double(year))
            let costGrowthFactor = pow(1 + projection.annualCostGrowthRate, Double(year))
            
            let annualRent = annualRentStart * rentGrowthFactor
            let annualNonAllocableCosts = baseNonAllocableCosts * costGrowthFactor
            
            var annualInterestExpense: Double = 0
            var annualPrincipalRepayment: Double = 0
            
            for index in remainingLoans.indices {
                let loan = loans[index]
                let currentBalance = remainingLoans[index]
                
                if currentBalance <= 0 {
                    continue
                }
                
                let annualInterest = currentBalance * loan.interestRate
                let annualAnnuity = loan.principal * (loan.interestRate + loan.initialRepaymentRate)
                let principalRepayment = max(annualAnnuity - annualInterest, 0)
                let adjustedRepayment = min(principalRepayment, currentBalance)
                
                annualInterestExpense += annualInterest
                annualPrincipalRepayment += adjustedRepayment
                
                remainingLoans[index] = max(currentBalance - adjustedRepayment, 0)
            }
            
            let annualCashflowBeforeTax =
                annualRent
                - annualNonAllocableCosts
                - annualInterestExpense
                - annualPrincipalRepayment
            
            let annualCashflowAfterTax =
                annualCashflowBeforeTax * (1 - projection.taxRate)
            
            cumulativeCashflowBeforeTax += annualCashflowBeforeTax
            cumulativeCashflowAfterTax += annualCashflowAfterTax
            
            if year == years {
                annualCashflowBeforeTaxAtExit = annualCashflowBeforeTax
                annualCashflowAfterTaxAtExit = annualCashflowAfterTax
            }
            
            let remainingLoanBalance = remainingLoans.reduce(0, +)
            
            let propertyValue: Double
            
            if projection.useExitFactor {
                propertyValue = annualRent * projection.exitFactor
            } else {
                propertyValue = input.purchasePrice *
                pow(1 + projection.annualAppreciationRate, Double(year))
            }
            
            let saleCosts = propertyValue * projection.sellingCostRate
            let netSale = propertyValue - saleCosts - remainingLoanBalance
            let equityValueAfterTax = netSale + cumulativeCashflowAfterTax
            let gain = equityValueAfterTax - input.equity
            
            if breakEvenYear == nil && gain > 0 {
                breakEvenYear = year
            }
            
            yearlyEntries.append(
                ProjectionYearEntry(
                    year: year,
                    annualRent: annualRent,
                    annualCashflowAfterTax: annualCashflowAfterTax,
                    remainingLoanBalance: remainingLoanBalance,
                    propertyValue: propertyValue,
                    equityValueAfterTax: equityValueAfterTax
                )
            )
        }
        
        let projectedRent = annualRentStart *
        pow(1 + projection.annualRentGrowthRate, Double(years))
        
        let projectedNonAllocableCosts = baseNonAllocableCosts *
        pow(1 + projection.annualCostGrowthRate, Double(years))
        
        let projectedPropertyValue: Double
        
        if projection.useExitFactor {
            projectedPropertyValue = projectedRent * projection.exitFactor
        } else {
            projectedPropertyValue = input.purchasePrice *
            pow(1 + projection.annualAppreciationRate, Double(years))
        }
        
        let projectedNOI = projectedRent - projectedNonAllocableCosts
        let projectedLoanBalance = remainingLoans.reduce(0, +)
        let saleCosts = projectedPropertyValue * projection.sellingCostRate
        let netSale = projectedPropertyValue - saleCosts - projectedLoanBalance
        
        let equityBeforeTax = netSale + cumulativeCashflowBeforeTax
        let equityAfterTax = netSale + cumulativeCashflowAfterTax
        
        let equityGainBeforeTax = equityBeforeTax - input.equity
        let equityGainAfterTax = equityAfterTax - input.equity
        
        return ProjectionResult(
            holdingPeriodYears: years,
            annualRentAtExit: projectedRent,
            annualNetOperatingIncomeAtExit: projectedNOI,
            annualCashflowBeforeTaxAtExit: annualCashflowBeforeTaxAtExit,
            annualCashflowAfterTaxAtExit: annualCashflowAfterTaxAtExit,
            projectedPropertyValue: projectedPropertyValue,
            projectedSaleCosts: saleCosts,
            projectedLoanBalance: projectedLoanBalance,
            netSaleProceeds: netSale,
            cumulativeCashflowBeforeTax: cumulativeCashflowBeforeTax,
            cumulativeCashflowAfterTax: cumulativeCashflowAfterTax,
            totalEquityValueBeforeTax: equityBeforeTax,
            totalEquityValueAfterTax: equityAfterTax,
            equityGainBeforeTax: equityGainBeforeTax,
            equityGainAfterTax: equityGainAfterTax,
            breakEvenYear: breakEvenYear,
            exitMethodLabel: projection.useExitFactor ? "Exit-Faktor" : "Wertsteigerung",
            yearlyEntries: yearlyEntries
        )
    }
}
