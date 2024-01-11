//
//  ContentView.swift
//  TheTip
//
//  Created by Trey Gaines on 1/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            AddMealView(selectedTab: $selectedTab) //Left tab
                .tabItem {
                    Label("Add Meal", systemImage: "plus")
                }
                .tag(0)

            RecentMealView() //Middle tab (Current View)
                .tabItem {
                    Label("Meals", systemImage: "list.dash")
                }
                .tag(1)

            StatsAndSettingsView() //Right tab (Stats/Settings)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .accentColor(.blue)//Accent Color for tabs
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Meal.self, inMemory: true)
}
