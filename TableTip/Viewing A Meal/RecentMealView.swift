//
//  RecentMealView.swift
//  TheTip
//
//  Created by Trey Gaines on 1/11/24.
//

import Foundation
import SwiftUI
import SwiftData

struct RecentMealView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var meals: [Meal]
    @State private var showingAddMealView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(meals) { meal in
                    NavigationLink(destination: MealDetailedView(meal: meal)) {
                        MealRowView(meal: meal)
                    }
                }
                .onDelete(perform: deleteMeals)
            }
            .navigationTitle("Recent Meals")
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
    RecentMealView()
}

