import SwiftUI
import EventKit

final class MainViewModel: ObservableObject {
    @Published var event: [EventModel] = []
    private let eventService = EventKitService.shared
    
    func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        eventService.requestCalendarAccess { granted in
            completion(granted)
        }
    }
    
    func fetchEventData() {
        eventService.fetchTodayEvents { [weak self] eventModel in
            DispatchQueue.main.async {
                self?.event = eventModel
                print(eventModel)
            }
        }
    }
}
