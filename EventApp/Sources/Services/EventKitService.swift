import EventKit

final class EventKitService {
    static let shared = EventKitService()
    
    let eventStore = EKEventStore()
    let calendar = Calendar.current
    
    
    func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        let authorizationStatus = EKEventStore.authorizationStatus(for: .event)
        switch authorizationStatus {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            self.eventStore.requestAccess(to: .event) { [weak self] granted, error in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        @unknown default:
            completion(false)
        }
    }
    
    func fetchTodayEvents(completion: @escaping ([EventModel]) -> Void) {
        let startDate = calendar.startOfDay(for: Date())
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let events = eventStore.events(matching: predicate)
        
        let eventModels = events.map { event in
            EventModel(id: event.eventIdentifier, title: event.title, startDate: event.startDate, endDate: event.endDate, location: event.location ?? "")
        }
        
        completion(eventModels)
    }
}
