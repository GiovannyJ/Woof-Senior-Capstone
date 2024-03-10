import CoreLocation
import MapKit
import Combine

class AddressFinderLogic: ObservableObject {
    @Published var searchResults: [AddressCompletion] = []
    
    public var completer = MKLocalSearchCompleter()
    public var completerDelegate: CompleterDelegate?
    public let locationManager = LocationManager.shared
    public let mapAPI = MapAPI()

    init() {
        completerDelegate = CompleterDelegate { results in
            self.searchResults = results
        }
        completer.delegate = completerDelegate
    }

    func startLocationSearch(withText text: String) {
        completer.queryFragment = text
    }
    
    func selectCompletion(_ completion: AddressCompletion) {
        mapAPI.getLocation(address: completion.subtitle, delta: 0.05)
        searchResults.removeAll()
    }
}
