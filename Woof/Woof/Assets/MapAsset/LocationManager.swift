//
//  LocationManager.swift
//  MapboxTestv4
//
//  Created by Martin on 2/18/24.


import Combine
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    
    // Published property to track authorization status changes
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    @Published public var userLocation: CLLocation?
    static let shared = LocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        print("Running Request")
        self.manager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        print("Starting location updates")
        self.manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stopping location updates")
        self.manager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Update the published property when authorization status changes
        authorizationStatus = status
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location authorization granted.")
        case .notDetermined:
            requestLocation()
        default:
            print("Location authorization denied.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
        
        // Print the user's location when tracking is enabled
        // print("User location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
}
