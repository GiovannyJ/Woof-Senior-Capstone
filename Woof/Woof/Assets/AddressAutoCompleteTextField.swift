//
//  AddressAutoCompleteTextField.swift
//  Woof
//
//  Created by Giovanny Joseph on 4/1/24.
//

import SwiftUI
import MapKit

class AddressAutocompleteViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var text: String = ""
    @Published var searchResults: [MKLocalSearchCompletion] = []
    private var completer = MKLocalSearchCompleter()
    private let geocoder = CLGeocoder()
    
    override init() {
        super.init()
        completer.delegate = self
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func startSearching(with query: String) {
        if !query.isEmpty {
            completer.queryFragment = query
        } else {
            searchResults.removeAll()
        }
    }
    
    func getAddress(for completion: MKLocalSearchCompletion, completionBlock: @escaping (String?) -> Void) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response, let mapItem = response.mapItems.first else {
                completionBlock(nil)
                return
            }
            
            var fullAddress = ""
            if let addressDictionary = mapItem.placemark.addressDictionary {
                if let addressLines = addressDictionary["FormattedAddressLines"] as? [String] {
                    fullAddress = addressLines.joined(separator: ", ")
                }
            }
            completionBlock(fullAddress)
        }
    }
}

struct AddressAutocompleteTextField: View {
    @Binding var text: String
    @StateObject var viewModel = AddressAutocompleteViewModel()
    
    var body: some View {
        VStack {
            TextField("Enter an address", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                
                .onChange(of: text) { newValue in
                    viewModel.startSearching(with: newValue)
                }
            
            if !viewModel.searchResults.isEmpty {
                List(viewModel.searchResults, id: \.self) { result in
                    VStack(alignment: .leading) {
                        Text(result.title)
                            .foregroundColor(.blue)
                        Text(result.subtitle)
                            .font(.caption)
                    }
                    .onTapGesture {
                        viewModel.getAddress(for: result) { address in
                            if let address = address {
                                text = address
                                viewModel.searchResults.removeAll()
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let text = "771 benris"
        return AddressAutocompleteTextField(text: .constant(text))
    }
}
