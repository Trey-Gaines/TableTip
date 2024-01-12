//
//  MonthStats.swift
//  TheTip
//
//  Created by Trey Gaines on 1/11/24.
//

import SwiftUI
import SwiftData

struct MonthStats: View {
    @Query private var meals: [Meal]
    @State private var moneySpent: Double = 0
    @State private var averageSpent: Double = 0
    @State private var restaurantsVisited: Int = 0
    @State private var favoriteRestaurant: String = ""

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                VStack {
                    Text("Money Spent")
                        .font(.headline)
                    Text("\(String(format: "$%.2f", moneySpent))")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)

                VStack {
                    Text("Average Spent")
                        .font(.headline)
                    Text("\(String(format: "$%.2f", averageSpent))")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
            }

            HStack {
                VStack {
                    Text("Restaurants Visited")
                        .font(.headline)
                    Text("\(restaurantsVisited)")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)

                VStack {
                    Text("Favorite Restaurant")
                        .font(.headline)
                    Text("\(favoriteRestaurant)")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
            }
        }
       
        .onAppear {
            updateStats()
        }
    }
    
    

    private func updateStats() {
        moneySpent = meals.getTotalSpend()
        averageSpent = meals.getAverageSpend()
        restaurantsVisited = meals.getResturantCount()
        favoriteRestaurant = meals.getFavorite()
    }
}


#Preview {
    MonthStats()
}

extension Array where Element: Meal {
    func getAverageSpend() -> Double {
        guard !self.isEmpty else {
            return 0.0
        }
        
        var moneyCount = 0.0
        for meal in self {
            moneyCount += meal.totalBill
        }
        return moneyCount / Double(self.count)
    }
    
    
    
    func getTotalSpend() -> Double {
        self.reduce(0.0) {
            $0 + $1.totalBill
        }
    }
    
    
    
    
    func getResturantCount() -> Int {
        let setOfLocations = Set(self)
        return setOfLocations.count
    }
    
    
    
    func getFavorite() -> String {
        var counts: [String:Int] = [:]
        var originalNames: [String: String] = [:]
        
        for meal in self {
            let normalized = meal.mealLocation
                .filter { $0.isLetter || $0.isNumber }
                .lowercased()
            
            counts[normalized, default: 0] += 1 //Store Frequency
            originalNames[normalized] = meal.mealLocation //Store Original Name. Overwriting with the last String seen that matches
        }
        
        if let mostFrequent = counts.max(by: { $0.value < $1.value })?.key {
            return originalNames[mostFrequent] ?? "None"
        } else {
            return "None"
        }
    }
    
    
}