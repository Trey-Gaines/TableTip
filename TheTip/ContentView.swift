//
//  ContentView.swift
//  TheTip
//
//  Created by Trey Gaines on 1/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    //Tag will be used to cycle through views in the tabView
    //0: AddMealView
    //1: RecentMealView
    //0: StatsAndSettingsView
    @State private var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            AddMealView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Add Meal", systemImage: "plus")
                }
                .tag(0)

            RecentMealView()
                .tabItem {
                    Label("Meals", systemImage: "list.dash")
                }
                .tag(1)

            StatsAndSettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Meal.self, inMemory: true)
}
