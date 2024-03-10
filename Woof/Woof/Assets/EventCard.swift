//
//  EventCard.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//
import SwiftUI

struct EventCard: View {
    let event: Event
    let type: String
    
    @EnvironmentObject var sessionManager: SessionManager // Injecting SessionManager
    
    private var buttonColor: Color {
        return type == "disabled" ? .gray : .teal
    }
    
    private var isDisabled: Bool {
        return type == "disabled"
    }
    
    var body: some View {
        NavigationLink(destination: type == "business" ? AnyView(UpdateEventView(event: event)) : AnyView(EventFullContextView(event: event))) {
            VStack(alignment: .leading, spacing: 8) {
                Text(event.eventName)
                    .font(.headline)
                Text(event.eventDescription)
                    .font(.subheadline)
                Text("Date: \(event.eventDate)") // Format the date
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
                
                HStack { // Attend and Unattend Event Buttons
                    Button(action: {
                        attendEvent(event: event)
                        print("Attend Event: \(event.eventName)")
                    }) {
                        Text("Attend Event")
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(buttonColor)
                            .cornerRadius(8)
                            .font(.headline)
                    }
                    .disabled(isDisabled)
                    
                    if let eventsAttending = sessionManager.eventsAttending,
                       eventsAttending.contains(where: { $0.eventID == event.eventID }) {
                        UnattendEventButton(event: event)
                    }
                }
            }
            .padding()
            .background(Color.teal.opacity(0.2))
            .cornerRadius(8)
        }
    }
    
    private func attendEvent(event: Event) {
        let url = URL(string: "http://localhost:8080/events/attendance")!
        let userID = SessionManager.shared.currentUser?.userID
        let body: [String: Any] = [
            "userID": userID ?? 0,
            "eventID": event.eventID,
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Error encoding data")
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
                    print("Event Attending!")
                    SessionManager.shared.fetchEventsAttending()
                case 400:
                    //MAKE POPUP HERE LATER
                    print("User is already attending event")
                case 500:
                    // Handle 500 error
                    print("Error: \(httpResponse.statusCode)")
                default:
                    // Handle other status codes
                    print("Unexpected error occurred")
                }
            }
        }.resume()
    }
}

struct EventCard_Preview: PreviewProvider {
    static let testEvent = Event(eventID: 1, attendance_count: 10, businessID: 1, contactInfo: "100-200-2020", dataLocation: "internal", disabledFriendly: true, eventDate: "2024-03-06", eventDescription: "This is a test event with test data and whatnot", eventName: "test event", imgID: nil, leashPolicy: true, location: "1800 Test Street", petSizePref: "small", geolocation: "thisplace")
    
    static var previews: some View {
        EventCard(event: testEvent, type: "disabled")
            .environmentObject(SessionManager.shared)
    }
}
