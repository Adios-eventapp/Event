//
//  EventWidget.swift
//  EventWidget
//
//  Created by 이재은 on 2023/06/24.
//

import WidgetKit
import SwiftUI
import Intents
import EventKit

struct EventEntry: TimelineEntry {
    let date: Date
    let events: [EventModel]
}

struct EventModel: Identifiable {
    let id: String
    let title: String
    let startDate: Date
    let endDate: Date
    let location: String
}

struct EventProvider: TimelineProvider {
    func placeholder(in context: Context) -> EventEntry {
        let date = Date()
        let placeholderEvent = EventModel(id: "placeholder", title: "Placeholder Event", startDate: date, endDate: date, location: "")
        return EventEntry(date: date, events: [placeholderEvent])
    }

    func getSnapshot(in context: Context, completion: @escaping (EventEntry) -> Void) {
        let date = Date()
        let snapshotEvent = EventModel(id: "snapshot", title: "Snapshot Event", startDate: date, endDate: date, location: "")
        let entry = EventEntry(date: date, events: [snapshotEvent])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<EventEntry>) -> Void) {
        var entries: [EventEntry] = []

        let eventStore = EKEventStore()
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let events = eventStore.events(matching: predicate)

        let eventModels = events.map { event in
            EventModel(id: event.eventIdentifier, title: event.title, startDate: event.startDate, endDate: event.endDate, location: event.location ?? "")
        }

        let currentDate = Date()
        let entry = EventEntry(date: currentDate, events: eventModels)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct EventWidgetEntryView: View {
    var entry: EventProvider.Entry

    var body: some View {
        VStack {
            if entry.events.isEmpty {
                Text("No events found")
            } else {
                ForEach(entry.events) { event in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(event.title)
                                .font(.headline)
                            Text(event.startDate, style: .time)
                                .font(.subheadline)

                        }
                        Text(event.location)
                            .font(.caption)
                    }
                }
            }
        }
    }
}

@main
struct EventWidget: Widget {
    let kind: String = "EventWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: EventProvider()) { entry in
            EventWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Event Widget")
        .description("Displays today's events")
    }
}
