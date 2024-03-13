//
//  LocationManager.swift
//  MapboxTestv4
//
//  Created by Martin on 2/18/24.


import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
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
        print("Success")
        print(manager.authorizationStatus)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
}
