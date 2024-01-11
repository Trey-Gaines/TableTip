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
            Text("Stats")
                .font(.largeTitle)
                .padding()
            
            Text("Settings")
                .font(.largeTitle)
                .padding()

            Picker("Mode", selection: $isDarkMode) {
                Text("Light").tag(false)
                Text("Dark").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Spacer()
        }
        .navigationTitle("Stats & Settings")
    }
}

#Preview {
    StatsAndSettingsView()
}