//
//  Meal.swift
//  TheTip
//
//  Created by Trey Gaines on 1/10/24.
//

import Foundation
import SwiftData

@Model
final class Meal: Identifiable {
    var id = UUID()
    var mealLocation: String
    var timestamp: Date
    var totalBill: Double
    var partySize: Int
    var tipPercentage: Int
    
    init(timestamp: Date, mealLocation: String, totalBill: Double, partySize: Int, tipPercentage: Int) {
        self.timestamp = timestamp
        self.mealLocation = mealLocation
        self.totalBill = totalBill
        self.partySize = partySize
        self.tipPercentage = tipPercentage
    }
}
