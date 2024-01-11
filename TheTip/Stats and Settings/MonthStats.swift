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
    private var moneySpent = 0//meals.getAverageSpend()
    private var resturantsVisited = 0//meals.getResturantCount()
    private var favoriteResutrant = 0
    
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    MonthStats()
}


extension Array where Element: Meal {
    func getAverageSpend() -> Double {
        var moneyCount = 0.0
        
        for meal in self {
            moneyCount += meal.totalBill
        }
        return moneyCount
    }
    
    func getResturantCount() -> Int {
        let setOfLocations = Set(self)
        return setOfLocations.count
    }
    
    func getFavoriteResturant() -> String {
        return ""
    }
}
