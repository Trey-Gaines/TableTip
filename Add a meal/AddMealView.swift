//
//  AddMealView.swift
//  TheTip
//
//  Created by Trey Gaines on 1/10/24.
//

import Foundation
import SwiftUI
import MapKit

struct AddMealView: View {
    @Environment(\.modelContext) var modelContext
        @Binding var selectedTab: Int
        
        @StateObject private var locationManager = LocationManager()
        @State private var selectedRestaurant: String?
        
        @State private var totalBill: Double = 0.0
        @State private var mealName: String = ""
        @State private var partySize: Int = 1
        @State private var tipPercentage: Int = 18
        @State private var showingAlert = false
        @State private var alertMessage = ""
    
    let tipPercentages = [0, 8, 10, 15, 20, 25]
    
    var tipValue: Double {
        return totalBill * (Double(tipPercentage) / 100)
    }
    
    var tipPerPerson: Double {
        return (partySize > 0) ? (tipValue) / Double(partySize) : 0
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Form {
                Section(header: Text("Meal Details").font(.headline)) {
                    TextField("Where was the meal?", text: $mealName)
                    
                    HStack {
                        Text("Table Bill:")
                        TextField("Total Bill", value: $totalBill, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .keyboardType(.decimalPad)
                    }
                    
                    Stepper("Party Size: \(partySize)", value: $partySize, in: 1...20)
                    
                    VStack {
                        Text("Tip Percentage:")
                        Picker("Tip Percentage", selection: $tipPercentage) {
                            ForEach(tipPercentages, id: \.self) {
                                Text("\($0)%")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    Picker("Select Restaurant", selection: $selectedRestaurant) {
                        ForEach(locationManager.nearbyRestaurants, id: \.self) { restaurant in
                            Text(restaurant.name ?? "Unknown").tag(restaurant.name ?? "")
                        }
                    }
                }
                
                
            }
            
        
            VStack {
                Text("Tip per Person: \(tipPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                    .font(.title2)
                    .padding(.top, 10)
                
                Button(action: {
                    if isValidMeal() {
                                saveMeal()
                            } else {
                                showingAlert = true
                            }
                }) {
                    Text("Add Meal")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 10)
                
                Text("Total Bill: \(totalBill + tipValue, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                    .font(.title2)
            }
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
            .padding()
        }
        .navigationTitle("Add A Meal")
        .onAppear {
            locationManager.requestLocation()
        }
        .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
    }
   
    private func clearForm() {
            mealName = ""
            totalBill = 0.0
            partySize = 1
            tipPercentage = 18
    }
    
    private func saveLastMeal(_ meal: Meal) {
        let defaults = UserDefaults.standard
        defaults.set(meal.totalBill, forKey: "lastTotalBill")
        defaults.set(meal.partySize, forKey: "lastPartySize")
        defaults.set(meal.mealLocation, forKey: "lastMealLocation")
        defaults.set(meal.timestamp, forKey: "savedDate")
    }
    
    
    private func isValidMeal() -> Bool {
        if mealName.isEmpty {
            alertMessage = "Meal location is required."
            return false
        }
        if totalBill <= 0 {
            alertMessage = "Total bill must be greater than zero."
            return false
        }
        return true
    }
    
    private func saveMeal() {
        let newMeal = Meal(timestamp: Date(), mealLocation: mealName, restuarantLocation: selectedRestaurant ?? "", totalBill: totalBill, partySize: partySize, tipPercentage: tipPercentage)
        modelContext.insert(newMeal)
        saveLastMeal(newMeal)
        clearForm()
        selectedTab = 1
    }
    
    
    
}






