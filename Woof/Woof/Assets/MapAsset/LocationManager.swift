//
//  LocationManager.swift
//  MapboxTestv4
//
//  Created by Martin on 2/18/24.


import Combine
import CoreLocation

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
        manager.startUpdatingLocation()
    }

    func requestLocation() {
        print("Running Request")
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        print("Starting location updates")
        manager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Update the published property when authorization status changes
        authorizationStatus = status
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
        
        // Print the user's location when tracking is enabled
        print("User location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
}
