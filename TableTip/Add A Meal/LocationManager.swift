//
//  LocationManager.swift
//  RecentMealsExtension
//
//  Created by Trey Gaines on 1/12/24.
//

import Foundation
import CoreLocation
import MapKit


extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude),\(longitude)"
    }
    public static let defaultLocation = CLLocationCoordinate2D(latitude: 37.3346, longitude: 122.0090)
}


class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    //@Published ensures any changes to this value will automatically pubishlish an event
    @Published var nearbyRestaurants: [MKMapItem] = [] //Updates the map with the locations nearby
    @Published var isAuthorized: Bool = false //Will hide map from user if they haven't allowed location

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation() //Location is requested when object is created
        updateAuthorizationStatus()
    }

    func requestLocation() { //Used to request the location of the user
        //It's done when a new object is created though so I'm not using it
        locationManager.requestLocation()
    }
    
    private func updateAuthorizationStatus() {
            let status = locationManager.authorizationStatus
            isAuthorized = status == .authorizedWhenInUse || status == .authorizedAlways
        }

    
    //The two locationManager functions are part of the CLLocationManagerDelegate protocol.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { //This one is called when new location data is available
        guard let location = locations.last else { return }
        Task { //Task allows for asynchronous code in concurrent locations
            //Calls aysnc search function with the most recent location, and waits to update the list of nearby restaurants
            self.nearbyRestaurants = await searchNearbyRestaurants(location: location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    //Async function to search for restaurants nearby and return an array of correlating Map objects
    func searchNearbyRestaurants(location: CLLocation) async -> [MKMapItem] {
        let request = MKLocalSearch.Request() //creates instance of MKLocalSearch Request
        request.naturalLanguageQuery = "Restaurant" //defines search request query
        request.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500) //Defines search request region

        let search = MKLocalSearch(request: request) //LocalSearch the search reques
        do { //Needed to execute search and handle errors as this function is asynchronous
            let response = try await search.start() //asynch search start and waits for results. await because there is time before request ends, try for possible errors
            return response.mapItems //If successful return array of MKMapItems
        } catch {
            print("Error: \(error.localizedDescription)")
            return [] //Else throw error and return empty array
        }
    }
    
    deinit { //This ensures that the object is destroyed correctly
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
}
