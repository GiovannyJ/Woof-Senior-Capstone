//
//  CompleterDelegate.swift
//  Woof
//
//  Created by Martin on 3/9/24.
//

import Foundation
import MapKit

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
