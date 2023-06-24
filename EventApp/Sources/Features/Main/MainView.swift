import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.fetchEvent, id: \.self) { _ in 
                
            }
        }
        .listStyle(.plain)
        .padding()
        .navigationBarTitle("Event App")
        .task {
            
        }
    }
}
