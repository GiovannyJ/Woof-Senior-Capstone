//
//  AddressFinderView.swift
//  LocationRequest
//
//  Created by Martin on 2/24/24.
//

import SwiftUI
import CoreLocation
import MapKit
import Combine

// Struct representing the address finder view
struct AddressFinderView: View {
    // Observed object to manage location updates
    @ObservedObject var locationManager = LocationManager.shared
    // State object to manage map-related data and UI updates
    @StateObject private var mapAPI = MapAPI()
    // Text input field for entering addresses
    @State private var text = ""
    // Array to store search results
    @State private var searchResults: [String] = []

    // Body view containing UI elements
    var body: some View {
        VStack {
            // Display map with annotations and user location
            if let userLocation = locationManager.userLocation {
                Map(coordinateRegion: $mapAPI.region, annotationItems: mapAPI.locations) { location in
                    MapMarker(coordinate: location.coordinate, tint: .red)
                }
                .onAppear {
                    // Add user's current location to map API locations
                    if let userLocation = locationManager.userLocation {
                        mapAPI.locations.append(Location(name: "Current Location", coordinate: userLocation.coordinate))
                        // Set initial map region to user's location
                        mapAPI.region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                    }
                }
                
                // Display name of the first location (current location)
                Text(mapAPI.locations.first?.name ?? "")
                    .padding()
            } else {
                // Show message while fetching user location
                Text("Fetching user location...")
                    .padding()
            }

            // Text field for entering addresses
            TextField("Enter an address", text: $text, onEditingChanged: { _ in
                // Clear the search results when the user starts editing
                searchResults.removeAll()
            })
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)

            // Button to trigger address search
            Button("Find address") {
                mapAPI.getLocation(address: text, delta: 0.05)
            }
            
            // List to display search results
            List(searchResults, id: \.self) { result in
                Text(result)
                    .onTapGesture {
                        // Handle tap on search result
                        text = result
                        mapAPI.getLocation(address: result, delta: 0.05)
                        searchResults.removeAll()
                    }
            }
            .padding(.horizontal)
        }
        .padding()
        // Update search results based on user input
        .onChange(of: text) { searchText in
            updateSearchResults(for: searchText)
        }
    }
    
    // Function to update search results based on user input
    private func updateSearchResults(for searchText: String) {
        // Placeholder filtering logic based on search text
        // For demonstration, sample search results are added
        searchResults = ["123 Main St, City", "456 Elm St, Town", "789 Oak St, Village"].filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
}


