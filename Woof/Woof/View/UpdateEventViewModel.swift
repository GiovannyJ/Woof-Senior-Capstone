//
//  UpdateEventViewModel.swift
//  Woof
//
//  Created by Giovanny Joseph on 3/6/24.
//

import Foundation

class UpdateEventViewModel: ObservableObject {
    @Published var event: Event
    
    init(event: Event) {
        self.event = event
    }
    
    func updateEvent() {
        // Convert leashPolicy and disabledFriendly to 1 or 0
        let leashPolicyValue = event.leashPolicy ? 1 : 0
        let disabledFriendlyValue = event.disabledFriendly ? 1 : 0
        
        let requestBody: [String: Any] = [
            "tablename": "events",
            "columns_old": ["eventID"],
            "values_old": [event.eventID],
            "columns_new": ["eventName", "eventDescription", "eventDate", "location", "contactInfo", "leashPolicy", "disabledFriendly", "petSizePref"],
            // Updated the values for leashPolicy and disabledFriendly
            "values_new": [event.eventName, event.eventDescription, event.eventDate, event.location, event.contactInfo, leashPolicyValue, disabledFriendlyValue, event.petSizePref]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("Error: Failed to serialize JSON")
            return
        }
        
        var request = URLRequest(url: URL(string: "http://localhost:8080/events")!)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Handle response as needed
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                // Event updated successfully, fetch the updated event
                self.getUpdatedEvent(eventID: self.event.eventID)
            } else {
                print("Error: Failed to update event")
            }
        }.resume()
    }
    
    func getUpdatedEvent(eventID: Int) {
        let urlString = "http://localhost:8080/events?eventID=\(eventID)"
        
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Decode the response data into Event object
            if let updatedEvent = try? JSONDecoder().decode(Event.self, from: data) {
                DispatchQueue.main.async {
                    // Update the event with the updated event data
                    self.event = updatedEvent
                }
            } else {
                print("Error: Failed to decode event data")
            }
        }.resume()
    }
}
