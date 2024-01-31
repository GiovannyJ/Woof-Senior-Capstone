//  LocalEventsView.swift
//  Woof
//
//  Created by Bo Nappie on 1/23/24.
//

import SwiftUI

struct LocalEvents: View {
    @State private var events: [Event] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pet-Friendly Events Near You")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()

            // Display a list of events created and promoted by businesses
            ScrollView {
                ForEach(events, id: \.eventID) { event in
                    EventCard(event: event)
                        .padding(.vertical, 8)
                }
            }
        }
        .padding()
        .onAppear {
            fetchEvents()
        }
        .navigationTitle("Local Events")
    }

    private func fetchEvents() {
        guard let url = URL(string: "http://localhost:8080/events") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([Event].self, from: data)
                    DispatchQueue.main.async {
                        events = decodedData
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

struct Event: Decodable {
    let eventID: Int
    let attendance_count: Int
    let businessID: Int
    let contactInfo: String
    let dataLocation: String
    let disabledFriendly: Bool
    let eventDate: String
    let eventDescription: String
    let eventName: String
    let imgID: ImageID
    let leashPolicy: Bool
    let location: String
    let petSizePref: String

    private enum CodingKeys: String, CodingKey {
        case eventID
        case attendance_count
        case businessID
        case contactInfo
        case dataLocation
        case disabledFriendly
        case eventDate
        case eventDescription
        case eventName
        case imgID
        case leashPolicy
        case location
        case petSizePref
    }
}


struct LocalEvents_Previews: PreviewProvider {
    static var previews: some View {
        LocalEvents()
    }
}

// EventCard
struct EventCard: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.eventName)
                .font(.headline)
            Text(event.eventDescription)
                .font(.subheadline)
            Text("Date: \(event.eventDate)")
            Text("Location: \(event.location)")
            Text("Contact: \(event.contactInfo)")
            // Additional event details can be displayed here
            
            // Example: Display attendance count
            Text("Attendance Count: \(event.attendance_count)")
                .font(.subheadline)
            
            // Example: Display pet-related preferences
            Text("Pet Size Preference: \(event.petSizePref)")
                .font(.subheadline)
            
            // Example: Display if leash policy is enforced
            Text("Leash Policy: \(event.leashPolicy ? "Enforced" : "Not Enforced")")
                .font(.subheadline)
            
            // Example: Display if disabled-friendly
            Text("Disabled Friendly: \(event.disabledFriendly ? "Yes" : "No")")
                .font(.subheadline)
        }
        .padding()
        .background(Color.teal.opacity(0.2))
        .cornerRadius(8)
    }
}
