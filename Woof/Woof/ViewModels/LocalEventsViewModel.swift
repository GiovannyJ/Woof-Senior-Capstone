//
//  LocalEventsViewModel.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import Foundation
import SwiftUI

class LocalEventsViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var annotations: [CustomAnnotation] = []
    
    func fetchEvents(type: String) {
        var urlString = "http://localhost:8080/events"
        if type == "business" {
            guard let ownedBusinessID = SessionManager.shared.ownedBusiness?.businessID else {
                print("Error: No owned business found")
                return
            }
            urlString += "?businessID=\(ownedBusinessID)"
        }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([Event].self, from: data)
                    DispatchQueue.main.async {
                        self.events = decodedData
                        self.updateAnnotations()
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error making API request: \(error)")
            }
        }.resume()
    }
    
    func updateAnnotations() {
        annotations.removeAll()
        for event in events {
            if let coordinates = ParseCoordinates(from: event.geolocation) {
                let annotation = CustomAnnotation(coordinate: coordinates, title: event.eventName + "\n" + event.location)
                annotations.append(annotation)
            }
        }
    }
}
