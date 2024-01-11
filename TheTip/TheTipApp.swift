//
//  TheTipApp.swift
//  TheTip
//
//  Created by Trey Gaines on 1/10/24.
//

import SwiftUI
import SwiftData

@main
struct TheTipApp: App {
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Meal.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .modelContainer(sharedModelContainer)
    }
}
