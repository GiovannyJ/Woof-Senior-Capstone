//
//  CreateNewEventViewModel.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import Foundation

class CreateEventViewModel: ObservableObject {
    @Published  var eventName: String = ""
    @Published  var eventDescription: String = ""
    @Published  var eventDate: Date = Date()
    @Published  var location: String = ""
    @Published  var contactInfo: String = ""
    @Published  var petSizePref: String = "small"
    @Published  var leashPolicy: Bool = false
    @Published  var disabledFriendly: Bool = false
    
    
    func submitEvent(completion: @escaping (Bool) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Specify the desired format
        let formattedDate = dateFormatter.string(from: eventDate)
        
        let businessID = SessionManager.shared.userBusinessID
        let url = URL(string: "http://localhost:8080/events/businesses/\(businessID ?? 0)")!
        let body: [String: Any] = [
            "eventName": eventName,
            "eventDescription": eventDescription,
            "eventDate": formattedDate,
            "location": location,
            "contactInfo": contactInfo,
            "petSizePref": petSizePref,
            "leashPolicy": leashPolicy,
            "disabledFriendly": disabledFriendly,
            "datalocation": "internal"
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Error encoding data")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 201:
                    // Successful response
                    print("Event Created!")
                    completion(true)
                case 500:
                    // Handle 500 error
                    print("Error: \(httpResponse.statusCode)")
                    completion(false)
                default:
                    // Handle other status codes
                    print("Unexpected error occurred")
                    completion(false)
                }
            }
        }.resume()
    }
}
