//
//  LocationManager.swift
//  RecentMealsExtension
//
//  Created by Trey Gaines on 1/12/24.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var nearbyRestaurants: [MKMapItem] = []

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
         if CLLocationManager.locationServicesEnabled() {
             switch locationManager.authorizationStatus {
             case .notDetermined:
                 // Request authorization
                 locationManager.requestWhenInUseAuthorization()
             case .restricted, .denied:
                 // Location permission has been denied or restricted
                 // Handle as needed, such as showing an alert
                 break
             case .authorizedAlways, .authorizedWhenInUse:
                 // Location permission granted, proceed to request location
                 locationManager.requestLocation()
             @unknown default:
                 break
             }
         } else {
             // Location services are not enabled
             // Handle as needed, such as showing an alert
         }
     }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        searchNearbyRestaurants(location: location)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    private func searchNearbyRestaurants(location: CLLocation) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Restaurant"
        request.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.nearbyRestaurants = response.mapItems
        }
    }
}
