//
//  LocationManager.swift
//  MapboxTestv4
//
//  Created by Martin on 2/18/24.

// This file contains a class named LocationManager that manages location-related tasks using CoreLocation.
// It also conforms to the CLLocationManagerDelegate protocol to handle location updates and authorization status changes.

import CoreLocation

// This is the LocationManager class, which is a subclass of NSObject and conforms to the ObservableObject protocol.
class LocationManager: NSObject, ObservableObject {
    // This creates a CLLocationManager instance to manage location services.
    private let manager = CLLocationManager()
    
    // This publishes the user's current location.
    @Published var userLocation: CLLocation?
    
    // This creates a shared instance of LocationManager, allowing access from other parts of the app.
    static let shared = LocationManager()
    
    // This is the initializer for the LocationManager class.
    override init() {
        super.init()
        
        // Set the delegate to self to receive location updates and authorization status changes.
        manager.delegate = self
        
        // Set the desired accuracy for location updates.
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Start updating the user's location.
        manager.startUpdatingLocation()
    }
    
    // This method requests location authorization when called.
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }
}

// Extension of LocationManager to handle CLLocationManagerDelegate methods.
extension LocationManager: CLLocationManagerDelegate {
    // This method is called when the authorization status changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Switch on the authorization status to handle different cases.
        switch status {
        case .notDetermined:
            print("DEBUG: Not Determined") // Authorization status is not determined.
        case .restricted:
            print("DEBUG: Not Restricted") // Authorization status is restricted.
        case .denied:
            print("DEBUG: Denied") // Authorization status is denied.
        case .authorizedAlways:
            print("DEBUG: Auth always") // Authorization status is always authorized.
        case .authorizedWhenInUse:
            print("DEBUG: Auth when in use") // Authorization status is authorized when in use.
        @unknown default:
            break
        }
    }
    
    // This method is called when the location manager receives new location updates.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get the most recent location from the locations array.
        guard let location = locations.last else { return }
        
        // Update the userLocation property with the new location.
        self.userLocation = location
    }
}

