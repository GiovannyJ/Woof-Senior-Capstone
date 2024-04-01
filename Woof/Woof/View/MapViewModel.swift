//
//
//  MapView.swift
//  LocationRequest
//
//  Created by Martin on 2/24/24.
//


import SwiftUI
import CoreLocation
import MapKit

struct MapViewModel: View {
    // Observed object to manage location updates
    @ObservedObject public var locationManager = LocationManager.shared
//    @State private var useUserLocation = true
    var centerCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationView {
            Group {
                if let centerCoordinate = centerCoordinate {
                    // Display map view centered at the specified location
                    MapViewUI(centerCoordinate: centerCoordinate)
                } else if let userLocation = LocationManager.shared.userLocation {
//                    if let userLocation = LocationManager.shared.userLocation {
                        // Display map view centered at user's location
                       MapViewUI(centerCoordinate: userLocation.coordinate)
                            .onAppear {
                                // Get address from coordinates and add annotation to map
                                getAddressFromCoordinates(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude) { address in
                                    if let address = address {
                                        MapViewUI.mapView.addAnnotation(CustomAnnotation(coordinate: userLocation.coordinate, title: address))
                                    }
                                }
                            }
                    } else {
                        Button {
                            LocationManager.shared.requestLocation()
                        } label: {
                            Text("Allow location")
                                .padding()
                                .font(.headline)
                                .foregroundColor(Color(.systemBlue))
                        }
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.horizontal, -32)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .padding()
                    }
                }
            }
        }
    }


struct MapViewUI: UIViewRepresentable {
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
        let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        // Set the region for the map view
        mapView.setRegion(region, animated: true)
    }
    
    // Function to add annotation to the map view
    func addAnnotationToMap(coordinate: CLLocationCoordinate2D, title: String) {
        // Create a custom annotation object
        let annotation = CustomAnnotation(coordinate: coordinate, title: title)
        // Add the annotation to the map view
        MapViewUI.mapView.addAnnotation(annotation)
    }
}

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?

    // Initialize the annotation with a coordinate and title
    init(coordinate: CLLocationCoordinate2D, title: String?) {
        self.coordinate = coordinate
        self.title = title
    }
}

