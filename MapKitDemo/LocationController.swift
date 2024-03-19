//
//  LocationController.swift
//  MapKitDemo
//
//  Created by ksd on 19/03/2024.
//

import SwiftUI
import MapKit

final class LocationController: NSObject, ObservableObject {
    var locationManager: CLLocationManager?
    
    @Published var userCameraPosition = MapCameraPosition.automatic
    
    // Zoom faktor
    private var userSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    
    
    func checkIflocationIsEnabled(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.delegate = self
        }
    }
    private func checkLocationAuthorization() {
        guard let location = locationManager else { return }
        switch location.authorizationStatus {
        case .notDetermined:
            print("NotDetermined")
            location.requestWhenInUseAuthorization()
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorized")
            location.startUpdatingLocation()
        default:
            break
        }
    }
}

/// Delegate methods for CLLocationManager
extension LocationController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first {
            let userRegion = MKCoordinateRegion(center: userLocation.coordinate, span: userSpan)
            self.userCameraPosition = .region(userRegion)
        }
    }
}
