//
//  MapHelper.swift
//  Woof
//
//  Created by Giovanny Joseph on 4/1/24.
//

import Foundation
import SwiftUI
import MapKit

func ParseCoordinates(from geolocation: String) -> CLLocationCoordinate2D? {
    let components = geolocation.components(separatedBy: ",")
    guard components.count == 2,
          let latitude = Double(components[0]),
          let longitude = Double(components[1]) else {
        return nil
    }
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
}


func ForwardGeocoding(address: String, completion: @escaping (Result<String, Error>) -> Void) {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address) { (placemarks, error) in
        if let error = error {
            print("Failed to retrieve location: \(error)")
            completion(.failure(error))
            return
        }
        
        guard let placemarks = placemarks, let location = placemarks.first?.location else {
            print("No Matching Location Found")
            completion(.failure(GeocodingError.noLocationFound))
            return
        }
        
        let coordinate = location.coordinate
        let coordinateString = "\(coordinate.latitude),\(coordinate.longitude)"
        print("Coordinate string: \(coordinateString)")
        completion(.success(coordinateString))
    }
}

enum GeocodingError: Error {
    case noLocationFound
}
