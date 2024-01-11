//
//  MealRowView.swift
//  TheTip
//
//  Created by Trey Gaines on 1/11/24.
//

import Foundation

import SwiftUI
import SwiftData

struct MealRowView: View {
    var meal: Meal

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(meal.mealLocation)
                    .font(.headline)
                Text("Amount: \(meal.totalBill, format: .currency(code: "USD"))")
                    .font(.subheadline)
            }

            Spacer()

            Text(meal.timestamp, format: Date.FormatStyle(date: .numeric))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

