//
//  SwiftUIView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct EventFullContextView: View {
    @ObservedObject var viewModel: EventFullContextViewModel
    @ObservedObject var sessionManager = SessionManager.shared

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

            // Display image if available
            if let imageData = viewModel.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }

            Button(action: {
                viewModel.toggleAttendance()
            }) {
                Text(viewModel.isAttending ? "Unattend Event" : "Attend Event")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.isAttending ? Color.red : Color.teal)
                    .cornerRadius(8)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(Color.teal.opacity(0.2))
        .cornerRadius(8)
        .onAppear {
            viewModel.fetchEventImage()
            viewModel.isAttending = sessionManager.eventsAttending?.contains { $0.eventID == viewModel.event.eventID } ?? false
        }
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
        EventFullContextView(viewModel: EventFullContextViewModel(event: testEvent))
    }
}
