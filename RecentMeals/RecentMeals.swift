// I'm not using ConfigurationIntent, so I removed it
//  RecentMeals.swift
//  RecentMeals
//
//  Created by Trey Gaines on 1/12/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RecentMealsSimpleEntry {
        RecentMealsSimpleEntry(date: Date(), statistics: StatisticsLoader.loadStatistics())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RecentMealsSimpleEntry) -> ()) {
            let entry = RecentMealsSimpleEntry(date: Date(),  statistics: StatisticsLoader.loadStatistics())
            completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<RecentMealsSimpleEntry>) -> ()) {
            let entry = RecentMealsSimpleEntry(date: Date(), statistics: StatisticsLoader.loadStatistics())
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
    }
}

struct RecentMealsSimpleEntry: TimelineEntry {
    let date: Date
    let statistics: Statistics
}

struct RecentMealsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

        }
    }
}

struct RecentMeals: Widget {
    let kind: String = "RecentMeals"

    var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: Provider()) { entry in
                RecentMealsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            }
            .description(Text("Here's the information of your most recent meal"))
    }
}


#Preview(as: .systemSmall) {
    RecentMeals()
} timeline: {
    RecentMealsSimpleEntry(date: .now, statistics: mockStatistics)
    RecentMealsSimpleEntry(date: .now, statistics: mockStatistics)
}
