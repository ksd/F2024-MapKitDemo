//
//  LocationController.swift
//  MapKitDemo
//
//  Created by ksd on 19/03/2024.
//

import Foundation
import CoreLocation

final class LocationController: NSObject {
    var locationManager: CLLocationManager?
    
    func checkIflocationIsEnabled(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.delegate = self
        }
    }
}

/// Delegate methods for CLLocationManager
extension LocationController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}
