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
    
    @State private var eventImage: UIImage?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName:"pawprint.fill")
                                .font(.title)
                                .foregroundColor(.orange)
                            Text(viewModel.event.eventName)
                                .font(.largeTitle)
                                .foregroundColor(.orange)
            };
            Text(viewModel.event.eventDescription)
                .font(.subheadline)
                .foregroundColor(.teal)
            
            Text("Date: \(viewModel.event.eventDate)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.teal)
            
            Text("Location: \(viewModel.event.location)")
                .font(.headline)
                .foregroundColor(.teal)
            
            Text("Contact: \(viewModel.event.contactInfo)")
                .font(.headline)
                .foregroundColor(.teal)

            Text("Attendance Count: \(viewModel.event.attendance_count)")
                .font(.headline)
                .foregroundColor(.teal)

            Text("Pet Size Preference: \(viewModel.event.petSizePref)")
                .font(.headline)
                .foregroundColor(.teal)

            Text("Leash Policy: \(viewModel.event.leashPolicy ? "Enforced" : "Not Enforced")")
                .font(.headline)
                .foregroundColor(.teal)

            Text("Disabled Friendly: \(viewModel.event.disabledFriendly ? "Yes" : "No")")
                .font(.headline)
                .foregroundColor(.teal)

            if let uiImage = eventImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }

            Button(action: {
                viewModel.toggleAttendance()
            }) {
                Text(viewModel.isAttending ? "Unattend Event" : "Attend Event")
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .font(.callout)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.isAttending ? Color.red : Color.orange)
                    .cornerRadius(8)
                    .font(.title)
            }
        }
        .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.teal.opacity(0.2), Color.teal.opacity(0.4)]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(16)
        .onAppear {
            viewModel.fetchEventImage()
            viewModel.isAttending = sessionManager.eventsAttending?.contains { $0.eventID == viewModel.event.eventID } ?? false
        }
        
        .onReceive(viewModel.$imageData) { imageData in
            if let data = imageData, let uiImage = UIImage(data: data) {
                self.eventImage = uiImage
            }
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

        EventFullContextView(viewModel: EventFullContextViewModel(event: testEvent))
    }
}
