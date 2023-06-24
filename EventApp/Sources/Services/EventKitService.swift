import EventKit

final class EventKitService {
    static let shared = EventKitService()
    
    let eventStore = EKEventStore()
    
    func requestAccessToCalendar() {
        self.eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            
        })
    }
    
}
