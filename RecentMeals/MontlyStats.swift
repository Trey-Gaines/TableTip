//I'm not using ConfigurationIntent, so I removed it
//  MonthlyStats.swift
//  TableTip
//
//  Created by Trey Gaines on 1/12/24.
//

import WidgetKit
import SwiftUI

struct MonthlyStatsProvider: TimelineProvider {
    func placeholder(in context: Context) -> MonthlyStatsSimpleEntry {
        MonthlyStatsSimpleEntry(date: Date(), statistics: StatisticsLoader.loadStatistics())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MonthlyStatsSimpleEntry) -> ()) {
            let entry = MonthlyStatsSimpleEntry(date: Date(), statistics: StatisticsLoader.loadStatistics())
            completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MonthlyStatsSimpleEntry>) -> ()) {
            let entry = MonthlyStatsSimpleEntry(date: Date(), statistics: StatisticsLoader.loadStatistics())
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
    }
}

struct MonthlyStatsSimpleEntry: TimelineEntry {
    let date: Date
    let statistics: Statistics
}
    
struct MonthlyStatsEntryView: View {
    var entry: MonthlyStatsProvider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

        }
    }
}

struct MonthlyStats: Widget {
    let kind: String = "MonthlyStats"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MonthlyStatsProvider()) { entry in
            MonthlyStatsEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .description(Text("Here are your stats for the month"))
    }
}




#Preview(as: .systemSmall) {
    MonthlyStats()
} timeline: {
    MonthlyStatsSimpleEntry(date: .now, statistics: mockStatistics)
    MonthlyStatsSimpleEntry(date: .now, statistics: mockStatistics)
}
