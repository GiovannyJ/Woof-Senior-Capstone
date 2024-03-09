//
//  TestMapView.swift
//  LocationRequest
//
//  Created by Martin on 2/24/24.
//

import SwiftUI
import CoreLocation
import MapKit

// Main content view
struct TestMapView: View {
    // Observed object to manage location updates
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        NavigationView {
            Group {
                // Check if user location is available
                if let userLocation = locationManager.userLocation {
                    // Display map view centered at user's location
                    MapView(centerCoordinate: userLocation.coordinate)
                        .onAppear {
                            // Get address from coordinates and add annotation to map
                            getAddressFromCoordinates(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude) { address in
                                if let address = address {
                                    addAnnotationToMap(mapView: MapView.mapView, coordinate: userLocation.coordinate, title: address)
                                }
                            }
                        }
                } else {
                    // Show location request view if user location is not available
                    LocationRequestView()
                }
            }
            // Set navigation title
            .navigationTitle("Current Location")
        }
    }
}

// Map view represented by a UIView
struct MapView: UIViewRepresentable {
    // Static instance of MKMapView
    static var mapView = MKMapView()

    // Center coordinate of the map
    let centerCoordinate: CLLocationCoordinate2D

    // Create the UIView representing the map
    func makeUIView(context: Context) -> MKMapView {
        // Disable the default blue dot indicating user location
        Self.mapView.showsUserLocation = false
        return Self.mapView
    }

    // Update the UIView when the center coordinate changes
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Define the region based on the center coordinate
        let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        // Set the region for the map view
        mapView.setRegion(region, animated: true)
    }
}

// Function to add annotation to the map view
func addAnnotationToMap(mapView: MKMapView, coordinate: CLLocationCoordinate2D, title: String) {
    // Create a custom annotation object
    let annotation = CustomAnnotation(coordinate: coordinate, title: title)
    // Add the annotation to the map view
    mapView.addAnnotation(annotation)
}

// Custom annotation class conforming to MKAnnotation protocol
class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?

    // Initialize the annotation with a coordinate and title
    init(coordinate: CLLocationCoordinate2D, title: String?) {
        self.coordinate = coordinate
        self.title = title
    }
}

