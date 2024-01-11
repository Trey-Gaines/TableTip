import Foundation
import SwiftUI

struct AddMealView: View {
    @Environment(\.modelContext) var modelContext
    @State private var totalBill: Double = 0.0
    @State private var mealName: String = ""
    @State private var partySize: Int = 1
    @State private var tipPercentage: Int = 18
    
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
                        InputForTableBill(value: $totalBill)
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
                }
            }
            
            VStack {
                Text("Tip per Person: \(tipPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                    .font(.title2)
                    .padding(.top, 10)

                Button(action: {
                    let newMeal = Meal(timestamp: Date(), mealLocation: mealName, totalBill: totalBill, partySize: partySize, tipPercentage: tipPercentage)
                    modelContext.insert(newMeal)
                    clearForm()
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
        }
        .navigationTitle("Add A Meal")
    }
    
    private func clearForm() {
            mealName = ""
            totalBill = 0.0
            partySize = 1
            tipPercentage = 18
        }
}
