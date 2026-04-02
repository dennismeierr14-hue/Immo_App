import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = InvestmentViewModel()
    
    var body: some View {
        TabView {
            
            DashboardView(viewModel: viewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
            
            PropertyInputView(viewModel: viewModel)
                .tabItem {
                    Label("Objekt", systemImage: "building.2.fill")
                }
            
            CostInputView(viewModel: viewModel)
                .tabItem {
                    Label("Kosten", systemImage: "eurosign.circle.fill")
                }
            
            FinancingView(viewModel: viewModel)
                .tabItem {
                    Label("Finanz.", systemImage: "banknote.fill")
                }
            
            ProjectionView(viewModel: viewModel)
                .tabItem {
                    Label("Zukunft", systemImage: "clock.arrow.circlepath")
                }
        }
    }
}
