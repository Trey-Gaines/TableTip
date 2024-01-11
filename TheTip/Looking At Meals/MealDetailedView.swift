//
//  MealDetailedView.swift
//  TheTip
//
//  Created by Trey Gaines on 1/11/24.
//

import Foundation
import SwiftUI
import SwiftData

struct MealDetailedView: View {
    var meal: Meal

    var body: some View {
        VStack(alignment: .leading) {
            Text("Meal at \(meal.mealLocation)")
                .font(.title)

            Text("Amount: \(meal.totalBill, format: .currency(code: "USD"))")
            Text("Date: \(meal.timestamp, format: Date.FormatStyle(date: .long))")
            Spacer()
        }
        .padding()
        .navigationTitle("Meal Details")
    }
}



