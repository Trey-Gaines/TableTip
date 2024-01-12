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
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Location:")
                        .fontWeight(.bold)
                        .font(.title3)
                    Text(meal.mealLocation)
                        .font(.title3)
                    Spacer()
                }

                HStack {
                    Text("Date:")
                        .fontWeight(.bold)
                        .font(.title3)
                    Text(meal.timestamp, format: Date.FormatStyle(date: .long))
                        .font(.title3)
                    Spacer()
                }

                HStack {
                    Text("Total Bill:")
                        .fontWeight(.bold)
                        .font(.title3)
                    Text(meal.totalBill, format: .currency(code: "USD"))
                        .font(.title3)
                    Spacer()
                }

                HStack {
                    Text("Party Size:")
                        .fontWeight(.bold)
                        .font(.title3)
                    Text("\(meal.partySize)")
                        .font(.title3)
                    Spacer()
                }

                HStack {
                    Text("Tip Percentage:")
                        .fontWeight(.bold)
                        .font(.title3)
                    Text("\(meal.tipPercentage)%")
                        .font(.title3) 
                    Spacer()
                }
            }
            .padding()
        }
        .navigationTitle("Meal at \(meal.mealLocation)")
    }
}
