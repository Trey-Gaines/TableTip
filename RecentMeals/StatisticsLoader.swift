// Helper unction for the RecentMeals and MonthlyStats provider
//  StatisticsLoader.swift
//  TableTip
//
//  Created by Trey Gaines on 1/12/24.
//

import Foundation

struct Statistics {
    //These store all the data returned by: saveLastMeal() in AddMealView & second half of updateStats() in MonthStats
    var moneySpentMonthly: Double
    var averageSpent: Double
    var restaurantsVisitedMonthly: Int
    var favoriteRestaurantThisMonth: String
    
    var mostRecentMealLocation: String
    var mostRecentTimestamp: Date
    var mostRecentBill: Double
    var mostRecentpartySize: Int
}



//First time working in WidgetKit but I realized later on user.defaults isn't safe for data storage
//Will try out something else in the future
struct StatisticsLoader {
    static func loadStatistics() -> Statistics {
        let defaults = UserDefaults.standard
        let moneySpentMonthly = defaults.double(forKey: "moneySpent")
        let averageSpent = defaults.double(forKey: "averageSpent")
        let restaurantsVisitedMonthly = defaults.integer(forKey: "restaurantsVisited")
        let favoriteRestaurantThisMonth = defaults.string(forKey: "favoriteRestaurant") ?? ""
        
        
        let mostRecentMealLocation = defaults.string(forKey: "lastMealLocation") ?? ""
        let mostRecentTimestamp: Date
        if let loadedDate = defaults.object(forKey: "savedDate") as? Date {
            mostRecentTimestamp = loadedDate
        } else {
            mostRecentTimestamp = Calendar.current.date(from: DateComponents(year: 1990, month: 1, day: 1))!
        }
        let mostRecentBill = defaults.double(forKey: "lastTotalBill")
        let mostRecentpartySize = defaults.integer(forKey: "lastPartySize")
        
        return Statistics(moneySpentMonthly: moneySpentMonthly, averageSpent: averageSpent, restaurantsVisitedMonthly: restaurantsVisitedMonthly, favoriteRestaurantThisMonth: favoriteRestaurantThisMonth, mostRecentMealLocation: mostRecentMealLocation, mostRecentTimestamp: mostRecentTimestamp, mostRecentBill: mostRecentBill, mostRecentpartySize: mostRecentpartySize)
    }
}

//Using fake object and passing to preview for Canvas
let mockStatistics = Statistics(
    moneySpentMonthly: 100.0,
    averageSpent: 20.0,
    restaurantsVisitedMonthly: 5,
    favoriteRestaurantThisMonth: "Example Restaurant",
    mostRecentMealLocation: "Test Location",
    mostRecentTimestamp: Date(),
    mostRecentBill: 50.0,
    mostRecentpartySize: 2
)
