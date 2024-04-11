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
    var centerCoordinate: CLLocationCoordinate2D?
    @State var annotations: [CustomAnnotation] = []
    
    var body: some View {
        NavigationView {
            Group {
                if let centerCoordinate = centerCoordinate {
                    // Display map view centered at the specified location
                    MapViewUI(centerCoordinate: centerCoordinate, annotations: annotations)
                } else if let userLocation = LocationManager.shared.userLocation {
                    // Display map view centered at user's location
                    MapViewUI(centerCoordinate: userLocation.coordinate, annotations: annotations)
                        .onAppear {
                            // Get address from coordinates and add annotation to map
                            getAddressFromCoordinates(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude) { address in
                                if let address = address {
                                    MapViewUI.mapView.addAnnotation(CustomAnnotation(coordinate: userLocation.coordinate, title: address, type: "user"))
                                }
                            }
                        }
                } else {
                    // Button to request location permission
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

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var type: String
    var event: Event? // Making it optional

    init(coordinate: CLLocationCoordinate2D, title: String?, type: String, event: Event? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.type = type
        self.event = event
    }
}

struct MapViewUI: UIViewRepresentable {
    var navigationBinding: Binding<Bool>?
    var eventDestinationViewModel: EventFullContextViewModel?
    @State private var showEventFullContext = false

    static var mapView = MKMapView()
    
    let centerCoordinate: CLLocationCoordinate2D
    let annotations: [CustomAnnotation]?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        Self.mapView.showsUserLocation = false
        Self.mapView.delegate = context.coordinator
        return Self.mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        mapView.removeAnnotations(mapView.annotations)
        if let annotations = annotations {
            for annotation in annotations {
                let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
                marker.canShowCallout = true
                marker.calloutOffset = CGPoint(x: -5, y: 5)
                marker.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                marker.markerTintColor = UIColor.orange
                marker.glyphImage = UIImage(systemName: "pawprint.fill") // Set the custom marker image
                mapView.addAnnotation(marker.annotation!)
            }
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewUI
        
        init(_ parent: MapViewUI) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? CustomAnnotation {
                if annotation.type == "event" {
                    if let event = annotation.event {
                        let eventViewModel = EventFullContextViewModel(event: event)
                        let eventFullContextView = EventFullContextView(viewModel: eventViewModel)
                        // Present the EventFullContextView modally
                        UIApplication.shared.windows.first?.rootViewController?.present(UIHostingController(rootView: eventFullContextView), animated: true)
                        
                        mapView.deselectAnnotation(annotation, animated: true)
                    }
                }
            }
        }
    }
}
