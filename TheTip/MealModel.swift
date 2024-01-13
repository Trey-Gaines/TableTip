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
    var id = UUID() //Unique ID for each Model
    var mealLocation: String //User Input for name
    var restuarantLocation: String? //MapKit location (Address)
    var timestamp: Date //Visit Time
    var totalBill: Double //Table Bill
    var partySize: Int //Amount of People
    var tipPercentage: Int //Tip Percentage
    
    init(timestamp: Date, mealLocation: String, restuarantLocation: String?, totalBill: Double, partySize: Int, tipPercentage: Int) {
        self.timestamp = timestamp
        self.mealLocation = mealLocation
        if restuarantLocation != nil {
            self.restuarantLocation = restuarantLocation
        } else {
            self.restuarantLocation = ""
        }
        self.totalBill = totalBill
        self.partySize = partySize
        self.tipPercentage = tipPercentage
    }
}
