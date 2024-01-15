//
//  Meal.swift
//  TheTip
//
//  Created by Trey Gaines on 1/10/24.
//

import Foundation
import SwiftData
import MapKit

@Model
final class Meal: Identifiable {
    var id = UUID()
    var mealLocation: String //Store user's input for the resturant name
    var latitude: Double? // Store latitude
    var longitude: Double? // Store longitude
    var timestamp: Date //Set time visited
    var totalBill: Double //Add the bill
    var partySize: Int //Add the party size
    var tipPercentage: Int //add the tip percentage
    
    init(timestamp: Date, mealLocation: String, restaurantLatitude: Double?, restaurantLongitude: Double?, totalBill: Double, partySize: Int, tipPercentage: Int) {
        self.timestamp = timestamp
        self.mealLocation = mealLocation
        self.latitude = restaurantLatitude
        self.longitude = restaurantLongitude
        self.totalBill = totalBill
        self.partySize = partySize
        self.tipPercentage = tipPercentage
    }

    // CLLocationCoordinate2D doesn't conform to PersistentModel so this makes it easy to still use a CLLocationCoordinate2D
    var restaurantCoordinates: CLLocationCoordinate2D? {
        get {
            guard let lat = latitude, let lon = longitude else { return nil }
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        set {
            latitude = newValue?.latitude
            longitude = newValue?.longitude
        }
    }
}
