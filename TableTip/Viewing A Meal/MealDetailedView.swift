//
//  MealDetailedView.swift
//  TheTip
//
//  Created by Trey Gaines on 1/11/24.
//

import Foundation
import SwiftUI
import MapKit

struct MealDetailedView: View {
    var meal: Meal
    @State private var cameraPosition: MapCameraPosition

    //We're working with a meal object so it's required to initialize the view with a specific Meal object and set up the initial state of the cameraPosition based on the meal's location
    init(meal: Meal) {
        self.meal = meal //pass the specific object into the view
        //If the meal has coordinates
        if let coordinates = meal.restaurantCoordinates {
            //set the Map(position: ) variable
            self._cameraPosition = State(initialValue: .region(MKCoordinateRegion(center: coordinates, latitudinalMeters: 200, longitudinalMeters: 200)))
        } else { //Else set the position to automatic
            self._cameraPosition = State(initialValue: MapCameraPosition.automatic)
        }
    }

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
                    Text("Tip Given:")
                        .fontWeight(.bold)
                        .font(.title3)
                    Text("\(meal.tipPercentage)%")
                        .font(.title3)
                    Spacer()
                }
                
                // Display map if location coordinates are available
                if meal.restaurantCoordinates != nil {
                    Map(position: $cameraPosition) {
                        Annotation(
                            "\(meal.mealLocation)",
                            coordinate: meal.restaurantCoordinates ?? .defaultLocation,
                            anchor: .bottom
                        ){
                            Image(systemName: "fork.knife")
                                .padding(4)
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(6)
                        }
                    }
                    //Set the size of the map view
                    .frame(height: 250)
                    .cornerRadius(10)
                    .padding()
                } else { //Else tell the user there's no data
                    Text("No location data available.")
                }
            }
            .padding()
        }
        .navigationTitle("Meal at \(meal.mealLocation)")
    }
}


//This was just to set the view
struct MealDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        let mockMeal = Meal(
            timestamp: Date(),
            mealLocation: "Sample Restaurant",
            restaurantLatitude: 40.7128,
            restaurantLongitude: -74.0060,
            totalBill: 100.00,
            partySize: 4,
            tipPercentage: 15
        )
        MealDetailedView(meal: mockMeal)
    }
}

