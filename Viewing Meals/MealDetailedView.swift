//
//  MealDetailedView.swift
//  TheTip
//
//  Created by Trey Gaines on 1/11/24.
//

import Foundation
import SwiftUI
import SwiftData
import MapKit

struct MealDetailedView: View {
    var meal: Meal
    @State private var coordinate: CLLocationCoordinate2D?

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
            
            VStack {
                if let coordinate = coordinate {
                    MapView(coordinate: coordinate)
                        .frame(height: 200)
                        .cornerRadius(10)
                        .padding()
                } else {
                    Text("Loading map...")
                        .onAppear {
                            getCoordinates(for: meal.mealLocation) { coord in
                                self.coordinate = coord
                            }
                        }
                }
            }
        }
        .navigationTitle("Meal at \(meal.mealLocation)")
    }
}



private func getCoordinates(for address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address) { placemarks, error in
        guard let placemark = placemarks?.first, let location = placemark.location else {
            completion(nil)
            return
        }
        completion(location.coordinate)
    }
    
    
    
}

