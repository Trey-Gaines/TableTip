//
//  StatAndSettingsView.swift
//  TheTip
//
//  Created by Trey Gaines on 1/11/24.
//

import SwiftUI

struct StatsAndSettingsView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some View {
        VStack {
            //Montly Stats at top
            Text("Monthly Stats")
                .font(.largeTitle)
            
            MonthStats() //Month Stats View
                .padding()
            
            Text("Settings")
                .font(.largeTitle)
                .padding()

            //Picker for user preference on color mode
            Picker("Mode", selection: $isDarkMode) {
                Text("Light").tag(false)
                Text("Dark").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

        Button("Open App Settings") { //Button to open App Settings
                openAppSettings()
                }
            }
        .navigationTitle("Stats & Settings")
    }
    
    private func openAppSettings() {
        guard let appSettings = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(appSettings) else {
            return
        }
        UIApplication.shared.open(appSettings)
    }
}

#Preview {
    StatsAndSettingsView()
}
