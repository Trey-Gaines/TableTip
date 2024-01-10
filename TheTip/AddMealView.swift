//
//  AddMealView.swift
//  TheTip
//
//  Created by Trey Gaines on 1/10/24.
//

import Foundation
import SwiftUI



struct AddMealView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var isPresented: Bool
    @State private var totalBill: Double = 0.0
    @State private var mealName: String = ""
    @State private var partySize: Int = 1
    @State private var tipPercentage: Int = 18
    
    let tipPercentages = [8, 10, 15, 18, 20, 25, 30, 0]
    
    var body: some View {
        NavigationView {
            Form { 
                
                //Set the name of the meal to make searching easier
                TextField("Where was the meal?", text: $mealName)
                
                
                //Get the user's set currency with Locale.current.currency?.identifier -> if null USD
                TextField("Total Bill", value: $totalBill, format: .currency(code:  Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
                
                //Click up to increase amount of Party
                Stepper("Party Size: \(partySize)", value: $partySize, in: 1...20)
                
                //Picker to select Tip Percentage
                Picker("Tip Percentage", selection: $tipPercentage) {
                    ForEach(tipPercentages, id: \.self) {
                        Text("\($0)%")
                    }
                }
                
                Button("Add Meal") {
                    let newMeal = Meal(timestamp: Date(), mealLocation: mealName, totalBill: totalBill, partySize: partySize, tipPercentage: tipPercentage)
                    modelContext.insert(newMeal)
                    isPresented = false
                }
            }
            .navigationTitle("Add Meal")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
        }
    }
}
