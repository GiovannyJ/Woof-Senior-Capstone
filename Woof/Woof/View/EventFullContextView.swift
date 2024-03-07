//
//  SwiftUIView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct EventFullContextView: View {
    @ObservedObject var viewModel: EventFullContextViewModel
    @State private var isAttending = false // Track whether the user is attending the event
    @ObservedObject var sessionManager = SessionManager.shared

    
    private var buttonColor: Color {
        return isAttending ? .gray : .teal
    }
    
    public init(event: Event) {
        self.viewModel = EventFullContextViewModel(event: event)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Display event details
            Text(viewModel.event.eventName)
                .font(.headline)
            Text(viewModel.event.eventDescription)
                .font(.subheadline)
            Text("Date: \(viewModel.event.eventDate)")
            Text("Location: \(viewModel.event.location)")
            Text("Contact: \(viewModel.event.contactInfo)")
            // Additional event details can be displayed here

            // Example: Display attendance count
            Text("Attendance Count: \(viewModel.event.attendance_count)")
                .font(.subheadline)

            // Example: Display pet-related preferences
            Text("Pet Size Preference: \(viewModel.event.petSizePref)")
                .font(.subheadline)

            // Example: Display if leash policy is enforced
            Text("Leash Policy: \(viewModel.event.leashPolicy ? "Enforced" : "Not Enforced")")
                .font(.subheadline)

            // Example: Display if disabled-friendly
            Text("Disabled Friendly: \(viewModel.event.disabledFriendly ? "Yes" : "No")")
                .font(.subheadline)
            
            Button(action: {
                attendEvent(event: viewModel.event)
                print("Attend Event: \(viewModel.event.eventName)")
            }) {
                Text("Attend Event")
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(buttonColor)
                    .cornerRadius(8)
                    .font(.headline)
            }
            .disabled(isAttending)

            
            // Display image if available
            if let imageData = viewModel.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }
        }
        .padding()
        .background(Color.teal.opacity(0.2))
        .cornerRadius(8)
        .onAppear(){
            viewModel.fetchEventImage()
            // Check if the event ID is in the session manager's attending events
            isAttending = SessionManager.shared.eventsAttending?.contains { $0.eventID == viewModel.event.eventID } ?? false

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



struct EventFullContextView_Previews: PreviewProvider {
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

        // Create an instance of EventFullContextView
        EventFullContextView(event: testEvent)
    }
}


