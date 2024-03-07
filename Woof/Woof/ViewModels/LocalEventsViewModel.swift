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
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error making API request: \(error)")
            }
        }.resume()
    }
}
