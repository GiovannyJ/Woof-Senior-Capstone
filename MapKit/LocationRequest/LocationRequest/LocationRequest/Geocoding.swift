//
//  Geocoding.swift
//  LocationRequest
//
//  Created by Martin on 2/23/24.
//

import Foundation
import MapKit

// Function to get the address from coordinates
func getAddressFromCoordinates(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
    // Create a CLGeocoder instance to perform reverse geocoding
    let geoCoder = CLGeocoder()
    // Create a CLLocation object with the given latitude and longitude
    let location = CLLocation(latitude: latitude, longitude: longitude)

    // Perform reverse geocoding to get address details
    geoCoder.reverseGeocodeLocation(location) { placemarks, error in
        // Check if there are any placemarks returned
        guard let placemark = placemarks?.first else {
            // Call the completion handler with nil if no placemark is found
            completion(nil)
            return
        }

        // Array to store address components
        var addressComponents = [String]()

        // Extract sub-thoroughfare component if available
        if let subThoroughfare = placemark.subThoroughfare {
            addressComponents.append(subThoroughfare)
        }

        // Extract thoroughfare component if available
        if let thoroughfare = placemark.thoroughfare {
            addressComponents.append(thoroughfare)
        }

        // Extract locality component if available
        if let locality = placemark.locality {
            addressComponents.append(locality)
        }

        // Extract country component if available
        if let country = placemark.country {
            addressComponents.append(country)
        }

        // Join all address components into a single string separated by commas
        let address = addressComponents.joined(separator: ", ")
        // Call the completion handler with the address
        completion(address)
    }
}


