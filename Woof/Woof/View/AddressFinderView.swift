//
//  AddressFinderView.swift
//  LocationRequest
//
//  Created by Martin on 2/24/24.
//

//import SwiftUI
//import CoreLocation
//import MapKit
//import Combine
//
//class CompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
//    var resultsHandler: ([AddressCompletion]) -> Void
//    
//    init(resultsHandler: @escaping ([AddressCompletion]) -> Void) {
//        self.resultsHandler = resultsHandler
//    }
//    
//    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        var results: [AddressCompletion] = []
//        
//        let group = DispatchGroup()
//        
//        completer.results.prefix(5).forEach { completion in // Limit to first 5 completions
//            group.enter()
//            
//            let searchRequest = MKLocalSearch.Request(completion: completion)
//            let search = MKLocalSearch(request: searchRequest)
//            search.start { response, error in
//                defer {
//                    group.leave()
//                }
//                
//                guard let response = response, let mapItem = response.mapItems.first else { return }
//                
//                let title = completion.title
//                var subtitle = ""
//                
//                // Construct subtitle with address components
//                if let addressDictionary = mapItem.placemark.addressDictionary {
//                    if let addressLines = addressDictionary["FormattedAddressLines"] as? [String] {
//                        subtitle = addressLines.joined(separator: ", ")
//                    }
//                }
//                
//                let addressCompletion = AddressCompletion(title: title, subtitle: subtitle)
//                results.append(addressCompletion)
//            }
//        }
//        
//        group.notify(queue: .main) {
//            self.resultsHandler(results)
//        }
//    }
//}
//
//struct AddressFinderView: View {
//    @ObservedObject var locationManager = LocationManager.shared
//    @StateObject private var mapAPI = MapAPI()
//    @State private var text = ""
//    @State private var searchResults: [AddressCompletion] = []
//    @State private var completer = MKLocalSearchCompleter()
//    @State private var completerDelegate: CompleterDelegate?
//    @State private var debouncer = Debouncer(delay: 0.5)
//    
//    var body: some View {
//        VStack {
//            
//            MapViewModel()
//            Text(mapAPI.locations.first?.name ?? "")
//                .padding()
//            
//            
//            TextField("Enter an address", text: $text)
//                .textFieldStyle(.roundedBorder)
//                .padding(.horizontal)
//                .onChange(of: text) { newValue in
//                    completer.queryFragment = newValue
//                }
//            
//            List(searchResults, id: \.self) { completion in
//                VStack(alignment: .leading) {
//                    Text(completion.title)
//                        .foregroundColor(.blue)
//                    Text(completion.subtitle)
//                        .font(.caption)
//                }
//                .onTapGesture {
//                    text = "\(completion.subtitle)"
//                    mapAPI.getLocation(address: completion.subtitle, delta: 0.05)
//                    searchResults.removeAll()
//                }
//            }
//            .padding(.horizontal)
//        }
//        .padding()
//        .onAppear {
//            completerDelegate = CompleterDelegate { results in
//                searchResults = results
//            }
//            completer.delegate = completerDelegate
//            locationManager.startUpdatingLocation()
//        }
//        .onChange(of: text) { newValue in
//            if !newValue.isEmpty {
//                debouncer.debounce {
//                    mapAPI.getLocation(address: newValue, delta: 0.05)
//                }
//            } else {
//                // Cancel the debounce action when the text is empty
//                debouncer.cancel()
//                // Clear the search results when the text is empty
//                searchResults.removeAll()
//            }
//        }
//    }
//}
//
//struct Debouncer {
//    let delay: TimeInterval
//    private var timer: Timer?
//
//    init(delay: TimeInterval) {
//        self.delay = delay
//    }
//
//    mutating func debounce(action: @escaping () -> Void) {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
//            action()
//        }
//    }
//
//    mutating func cancel() {
//        timer?.invalidate()
//    }
//}
//
//
//#Preview {
//    AddressFinderView()
//}
