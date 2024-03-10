//
//  UnattendEventButton.swift
//  Woof
//
//  Created by Giovanny Joseph on 3/10/24.
//

import Foundation
import SwiftUI

struct UnattendEventButton: View {
    let event: Event

    var body: some View {
        Button(action: {
            unattendEvent()
        }) {
            Text("Unattend Event")
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.red)
                .cornerRadius(8)
                .font(.headline)
        }
    }

    private func unattendEvent() {
        let urlString = "http://localhost:8080/attendance"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        var requestBody: [String: Int] = [:]
        if let userID = SessionManager.shared.currentUser?.userID {
            requestBody = [
                "userID": userID,
                "eventID": event.eventID,
            ]
        } else {
            print("no userID")
            // Handle the case where userID is not available
            return
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error encoding request body: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                print("Event unattended successfully")
                SessionManager.shared.fetchEventsAttending()
            } else {
                print("Failed to unattend event")
            }
        }.resume()
    }
}

struct UnattendEventButton_Previews: PreviewProvider {
    static var previews: some View {
        let testEvent = Event(eventID: 1,
                              attendance_count: 10,
                              businessID: 1,
                              contactInfo: "test@example.com",
                              dataLocation: "internal",
                              disabledFriendly: true,
                              eventDate: "2024-01-09",
                              eventDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                              eventName: "Test Event",
                              imgID: nil,
                              leashPolicy: true,
                              location: "Test Location",
                              petSizePref: "Medium",
                              geolocation: "here")
        UnattendEventButton(event: testEvent)
    }
}
