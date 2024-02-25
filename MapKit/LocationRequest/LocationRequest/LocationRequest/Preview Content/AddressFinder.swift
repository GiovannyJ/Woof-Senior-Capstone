//
//  AddressFinder.swift
//  LocationRequest
//
//  Created by Martin on 2/24/24.
//

import Foundation
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

class MapAPI: ObservableObject {
    private let geocoder = CLGeocoder()
    
    @Published var region: MKCoordinateRegion
    @Published var locations: [Location] = []
    
    init() {
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.722200, longitude: -73.651110), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
        
        // Perform reverse geocoding to get the address of the current location
        if let userLocation = LocationManager.shared.userLocation {
            geocoder.reverseGeocodeLocation(userLocation) { placemarks, error in
                guard let placemark = placemarks?.first else {
                    print("Error getting placemark: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                // Construct the full address using various components
                var fullAddress = ""
                if let name = placemark.name { fullAddress += "\(name), " }
                if let thoroughfare = placemark.thoroughfare { fullAddress += "\(thoroughfare), " }
                if let locality = placemark.locality { fullAddress += "\(locality), " }
                if let administrativeArea = placemark.administrativeArea { fullAddress += "\(administrativeArea), " }
                if let postalCode = placemark.postalCode { fullAddress += "\(postalCode), " }
                if let country = placemark.country { fullAddress += "\(country)" }
                
                // Remove trailing comma and space
                if fullAddress.hasSuffix(", ") {
                    fullAddress = String(fullAddress.dropLast(2))
                }
                
                // Insert the full address into the locations array
                self.locations.insert(Location(name: fullAddress, coordinate: userLocation.coordinate), at: 0)
            }
        }
    }

    
    func getLocation(address: String, delta: Double) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                } else {
                    print("Unknown geocoding error")
                }
                return
            }
            
            DispatchQueue.main.async {
                let coordinates = location.coordinate
                // Setting the region to focus on the new coordinates
                self.region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
                // Removing previous location and adding the new location with the provided address
                self.locations.removeAll()
                self.locations.append(Location(name: address, coordinate: coordinates))
            }
        }
    }
}


