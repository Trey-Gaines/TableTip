//
//  MapView.swift
//  RecentMealsExtension
//
//  Created by Trey Gaines on 1/12/24.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        uiView.addAnnotation(annotation)

        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        uiView.setRegion(region, animated: true)
    }
}


