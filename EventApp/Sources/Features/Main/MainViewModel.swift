import SwiftUI
import EventKit

final class MainViewModel: ObservableObject {
    @Published var event: [EKEvent] = []
    
    
    func fetchEventData() {
        
    }
}
