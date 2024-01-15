// I tried to break this up into more views but broke this simple project many times...... Next time
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
    @FocusState private var billIsFocused: Bool
    
    //Stuff for location
    @State private var nearbyRestaurants: [MKMapItem] = []
    @State private var locationManager = LocationManager()
    @State private var selectedRestaurant: MKMapItem?
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var showNearbyRestaurants: Bool = false
    
    
    @State private var totalBill: Double = 0.0
    @State private var mealName: String = ""
    @State private var partySize: Int = 1
    @State private var tipPercentage: Int = 18
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isFirstView: Bool = true
    @State private var splitTip: Bool = true
    @State private var memberBills: [Double] = [] //Tracks party members' separate bills
    let tipPercentages = [0, 8, 10, 15, 20, 25]
    
    var tipValue: Double {
        return tableBill * (Double(tipPercentage) / 100)
    }
    
    var tipPerPerson: Double {
        return (partySize > 0) ? (tipValue) / Double(partySize) : 0
    }
    
    var tableBill: Double {
        totalBill + memberBills.reduce(0, +)
    }
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                if isFirstView { //If solo dining
                    Form {
                        Section(header: Text("Meal Details").font(.headline)) {
                            TextField("Where was the meal?", text: $mealName)
                            HStack {
                                Text("Table Bill:")
                                TextField("Total Bill", value: $totalBill, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .keyboardType(.decimalPad)
                                    .focused($billIsFocused)
                            }
                            
                            VStack {
                                Text("Tip Percentage:")
                                Picker("Tip Percentage", selection: $tipPercentage) {
                                    ForEach(tipPercentages, id: \.self) {
                                        Text("\($0)%")
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                        }
                        Section {
                            if locationManager.isAuthorized { //If location services have been enabled, show the map
                                Map(position: $position, selection: $selectedRestaurant) {
                                    if showNearbyRestaurants {
                                        ForEach(locationManager.nearbyRestaurants, id: \.self) { restaurant in
                                            Marker(restaurant.name ?? "", systemImage: "fork.knife.circle.fill", coordinate: restaurant.placemark.coordinate)
                                                .tint(.blue)
                                        }
                                    }
                                }
                                .frame(height: 200)
                                .cornerRadius(10)
                                .safeAreaInset(edge: .bottom) {
                                    Button("Places Nearby") {
                                        showNearbyRestaurants = true
                                        position = .automatic
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            } else {
                                Text("Location Services have been disabled. Enable in settings") //Else alert the user
                            }
                        }
                        
                        VStack(spacing: 16) {
                            Text("Tip to leave: \(tipPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                                .font(.headline)
                            
                            Button(action: {
                                if isValidMeal() {
                                    saveMeal()
                                } else {
                                    showingAlert = true
                                }
                            }) {
                                Text("Add Meal")
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 40)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            Text("Total Bill: \(totalBill + tipValue, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                    }
                    
                } else { //If with others
                    Form {
                        if !splitTip { //Split the Tip Group Logic
                            Section(header: Text("Meal Details").font(.headline)) {
                                TextField("Where was the meal?", text: $mealName)
                                HStack {
                                    Text("Personal Bill:")
                                    TextField("Total Bill", value: $totalBill, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .keyboardType(.decimalPad)
                                        .focused($billIsFocused)
                                }
                                Stepper("Party Size: \(partySize)", value: $partySize, in: 2...20)
                                Section(header: Text("Party Member Bills").font(.headline)) {
                                    ForEach(1..<partySize, id: \.self) { index in
                                        if index - 1 < memberBills.count {
                                            HStack(spacing: 10) {
                                                Text("Member \(index + 1)'s Bill:")
                                                TextField("Amount", value: $memberBills[index - 1], format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                                    .keyboardType(.decimalPad)
                                                    .focused($billIsFocused)
                                                Text("Total Bill: \(memberBills[index - 1] + tipPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                                            }
                                        }
                                    }
                                }
                                VStack {
                                    Text("Tip Percentage:")
                                    Picker("Tip Percentage", selection: $tipPercentage) {
                                        ForEach(tipPercentages, id: \.self) {
                                            Text("\($0)%")
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                }
                            }
                            Section {
                                if locationManager.isAuthorized { //If location services have been enabled, show the map
                                    Map(position: $position, selection: $selectedRestaurant) {
                                        if showNearbyRestaurants {
                                            ForEach(locationManager.nearbyRestaurants, id: \.self) { restaurant in
                                                Marker(restaurant.name ?? "", systemImage: "fork.knife.circle.fill", coordinate: restaurant.placemark.coordinate)
                                                    .tint(.blue)
                                            }
                                        }
                                    }
                                    .frame(height: 200)
                                    .cornerRadius(10)
                                    .safeAreaInset(edge: .bottom) {
                                        Button("Places Nearby") {
                                            showNearbyRestaurants = true
                                            position = .automatic
                                        }
                                        .buttonStyle(.borderedProminent)
                                    }
                                } else {
                                    Text("Location Services have been disabled. Enable in settings") //Else alert the user
                                }
                            }
                            
                            VStack(spacing: 16) {
                                Text("Tip per Person: \(tipPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                                    .font(.headline)
                                
                                Button(action: {
                                    if isValidMeal() {
                                        saveMeal()
                                    } else {
                                        showingAlert = true
                                    }
                                }) {
                                    Text("Add Meal")
                                        .foregroundColor(.white)
                                        .frame(width: 200, height: 40)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                Text("Total Bill: \(totalBill + tipPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                        } else { //Calculate Tips for the Group too logic
                            Section(header: Text("Meal Details").font(.headline)) {
                                TextField("Where was the meal?", text: $mealName)
                                HStack {
                                    Text("Personal Bill:")
                                    TextField("Total Bill", value: $totalBill, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .keyboardType(.decimalPad)
                                        .focused($billIsFocused)
                                }
                                Stepper("Party Size: \(partySize)", value: $partySize, in: 2...20)
                                Section(header: Text("Party Member Bills").font(.headline)) {
                                    ForEach(1..<partySize, id: \.self) { index in
                                        if index - 1 < memberBills.count {
                                            HStack(spacing: 10) {
                                                Text("Member \(index + 1)'s Bill:")
                                                TextField("Amount", value: $memberBills[index - 1], format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                                    .keyboardType(.decimalPad)
                                                    .focused($billIsFocused)
                                                                            
                                                Text("\(memberBills[index - 1] * (Double(tipPercentage) / 100), format: .currency(code: Locale.current.currency?.identifier ?? "USD")) tip. \((memberBills[index - 1] * (Double(tipPercentage) / 100) + memberBills[index - 1]), format: .currency(code: Locale.current.currency?.identifier ?? "USD")) Total")
                                            }
                                        }
                                    }
                                }
                                VStack {
                                    Text("Tip Percentage:")
                                    Picker("Tip Percentage", selection: $tipPercentage) {
                                        ForEach(tipPercentages, id: \.self) {
                                            Text("\($0)%")
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                }
                            }
                            
                            Section {
                                if locationManager.isAuthorized { //If location services have been enabled, show the map
                                    Map(position: $position, selection: $selectedRestaurant) {
                                        if showNearbyRestaurants {
                                            ForEach(locationManager.nearbyRestaurants, id: \.self) { restaurant in
                                                Marker(restaurant.name ?? "", systemImage: "fork.knife.circle.fill", coordinate: restaurant.placemark.coordinate)
                                                    .tint(.blue)
                                            }
                                        }
                                    }
                                    .frame(height: 200)
                                    .cornerRadius(10)
                                    .safeAreaInset(edge: .bottom) {
                                        Button("Places Nearby") {
                                            showNearbyRestaurants = true
                                            position = .automatic
                                        }
                                        .buttonStyle(.borderedProminent)
                                    }
                                } else {
                                    Text("Location Services have been disabled. Enable in settings") //Else alert the user
                                }
                            }
                            
                            VStack(spacing: 16) {
                                Text("Personal Tip: \(tipPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                                    .font(.headline)
                                
                                Button(action: {
                                    if isValidMeal() {
                                        saveMeal()
                                    } else {
                                        showingAlert = true
                                    }
                                }) {
                                    Text("Add Meal")
                                        .foregroundColor(.white)
                                        .frame(width: 200, height: 40)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                Text("Total Bill: \(totalBill + tipValue, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                        }
                    }
                }
            }
            .navigationTitle("Add A Meal")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                       if !isFirstView {
                           Button(action: {
                               splitTip.toggle()
                           }) {
                               Image(systemName: splitTip ? "lightswitch.off" : "lightswitch.on")
                                   .aspectRatio(contentMode: .fit)
                                   .frame(width: 24, height: 24)
                           }
                       }
                   }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if billIsFocused {
                        Button("Done") {
                            billIsFocused = false
                        }
                    }
                    Button(action: {
                        isFirstView.toggle()
                        if isFirstView {
                                partySize = 1
                            } else {
                                partySize = 2
                            }
                    }) {
                        Image(systemName: isFirstView ? "person.fill" : "person.3.fill")
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                    }
                }
            }
            .onAppear {
                Task {
                    if let location = locationManager.locationManager.location {
                        nearbyRestaurants = await locationManager.searchNearbyRestaurants(location: location)
                    }
                }
            }
            .onChange(of: partySize) { _, newSize in
                if newSize > memberBills.count { //If party size increases
                    //Append 0.0 for new members
                    memberBills.append(contentsOf: Array(repeating: 0.0, count: newSize - memberBills.count))
                } else if newSize < memberBills.count { //If party size decreases
                    //Remove last elements to match new size
                    memberBills.removeLast(memberBills.count - newSize)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    
    private func clearForm() {
        mealName = ""
        totalBill = 0.0
        partySize = 1
        tipPercentage = 15
        selectedRestaurant = nil
        showNearbyRestaurants = false
        isFirstView = true
        position =  .userLocation(fallback: .automatic)
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
        let restaurantLocation = selectedRestaurant?.placemark.coordinate
        
        let newMeal = Meal(
                timestamp: Date(),
                mealLocation: mealName,
                restaurantLatitude: restaurantLocation?.latitude,
                restaurantLongitude: restaurantLocation?.longitude,
                totalBill: totalBill,
                partySize: partySize,
                tipPercentage: tipPercentage)
        
        modelContext.insert(newMeal)
        saveLastMeal(newMeal)
        clearForm()
        selectedTab = 1
    }
}


struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView(selectedTab: .constant(0))
    }
}
