import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = InvestmentViewModel()
    
    var body: some View {
        TabView {
            
            PropertyInputView(viewModel: viewModel)
                .tabItem {
                    Label("Objekt", systemImage: "house")
                }
            
            RentAndReservesView(viewModel: viewModel)
                .tabItem {
                    Label("Miete", systemImage: "eurosign.circle")
                }
            
            DashboardView(viewModel: viewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar")
                }
            
            FinancingView(viewModel: viewModel)
                .tabItem {
                    Label("Finanzierung", systemImage: "banknote")
                }
            
            ProjectionView(viewModel: viewModel)
                .tabItem {
                    Label("Zukunft", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
    }
}

#Preview {
    ContentView()
}
