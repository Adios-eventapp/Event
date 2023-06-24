import SwiftUI

struct MainView: View {
    
    @ObservedObject private var viewModel = MainViewModel()
    
    var body: some View {
        List(viewModel.event, id: \.self){ _ in
            Text("ss")
        }
        .listStyle(.plain)
        .padding()
        .navigationBarTitle("Event App")
        .task {
            viewModel.fetchEventData()
        }
    }
}
