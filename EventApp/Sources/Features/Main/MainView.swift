import SwiftUI

struct MainView: View {
    
    @ObservedObject private var viewModel = MainViewModel()
    @State private var isCalendarAccessGranted = false

    var body: some View {
        VStack {
            if isCalendarAccessGranted {
                if viewModel.event.isEmpty {
                    Text("No events found")
                } else {
                    List(viewModel.event, id: \.id) { event in
                        VStack(alignment: .leading) {
                            Text(event.title)
                                .font(.headline)
                            Text(event.startDate, style: .time)
                                .font(.subheadline)
                            Text(event.location)
                                .font(.subheadline)
                        }
                    }
                    .listStyle(.plain)
                }
            } else {
                Text("Calendar access not granted")
            }

        }
        .padding()
        .navigationBarTitle("Event App")
        .task {
            viewModel.requestCalendarAccess { granted in
                isCalendarAccessGranted = granted
                if granted {
                    viewModel.fetchEventData()
                }
            }
        }
    }
}
