import Foundation
import EventKit

struct EventModel: Identifiable {
    let id: String
    let title: String
    let startDate: Date
    let endDate: Date
    let location: String
}
