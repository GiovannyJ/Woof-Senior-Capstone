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

class CompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    var resultsHandler: ([AddressCompletion]) -> Void
    
    init(resultsHandler: @escaping ([AddressCompletion]) -> Void) {
        self.resultsHandler = resultsHandler
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        var results: [AddressCompletion] = []
        
        let group = DispatchGroup()
        
        completer.results.prefix(5).forEach { completion in // Limit to first 5 completions
            group.enter()
            
            let searchRequest = MKLocalSearch.Request(completion: completion)
            let search = MKLocalSearch(request: searchRequest)
            search.start { response, error in
                defer {
                    group.leave()
                }
                
                guard let response = response, let mapItem = response.mapItems.first else { return }
                
                let title = completion.title
                var subtitle = ""
                
                // Construct subtitle with address components
                if let addressDictionary = mapItem.placemark.addressDictionary {
                    if let addressLines = addressDictionary["FormattedAddressLines"] as? [String] {
                        subtitle = addressLines.joined(separator: ", ")
                    }
                }
                
                let addressCompletion = AddressCompletion(title: title, subtitle: subtitle)
                results.append(addressCompletion)
            }
        }
        
        group.notify(queue: .main) {
            self.resultsHandler(results)
        }
    }
}

//struct AddressCompletion: Hashable {
//    var title: String
//    var subtitle: String
//}


struct AddressFinderView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject private var mapAPI = MapAPI()
    @State private var text = ""
    @State private var searchResults: [AddressCompletion] = []
    @State private var completer = MKLocalSearchCompleter()
    @State private var completerDelegate: CompleterDelegate?
    
    var body: some View {
        VStack {
            if locationManager.userLocation != nil {
                Map(coordinateRegion: $mapAPI.region, annotationItems: mapAPI.locations) { location in
                    MapMarker(coordinate: location.coordinate, tint: .red)
                }
                .onAppear {
                    if let userLocation = locationManager.userLocation {
                        mapAPI.locations.append(Location_MapAPI(name: "Current Location", coordinate: userLocation.coordinate))
                        mapAPI.region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                    }
                }
                Text(mapAPI.locations.first?.name ?? "")
                    .padding()
            } else {
                Text("Fetching user location...")
                    .padding()
            }

            TextField("Enter an address", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .onChange(of: text) { newValue in
                    completer.queryFragment = newValue
                }

            List(searchResults, id: \.self) { completion in
                VStack(alignment: .leading) {
                    Text(completion.subtitle)
                        .foregroundColor(.blue)
                    Text(completion.subtitle)
                        .font(.caption)
                }
                .onTapGesture {
                    text = "\(completion.subtitle)"
                    mapAPI.getLocation(address: completion.title, delta: 0.05)
                    searchResults.removeAll()
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            completerDelegate = CompleterDelegate { results in
                searchResults = results
            }
            completer.delegate = completerDelegate
        }
    }
}
