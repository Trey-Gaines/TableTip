//
//  ContentView.swift
//  TheTip
//
//  Created by Trey Gaines on 1/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var meals: [Meal]
    @State private var showingAddMealView = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(meals) { meal in
                    NavigationLink {
                        Text("Meal at \(meal.mealLocation)")
                    } label: {
                        Text("Meal at \(meal.mealLocation) on \(meal.timestamp, format: Date.FormatStyle(date: .numeric))")
                    }
                }
                .onDelete(perform: deleteMeals)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddMealView = true }) {
                        Label("Add Meal", systemImage: "plus")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: HStack {
                Text("Recent Meals")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Spacer()
            })
    #if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
    #endif
        } detail: {
            Text("Select a meal")
        }
                .sheet(isPresented: $showingAddMealView) {
                    AddMealView(isPresented: $showingAddMealView)
                }
            }
    

    private func deleteMeals(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(meals[index])
            }
            try? modelContext.save()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Meal.self, inMemory: true)
}
