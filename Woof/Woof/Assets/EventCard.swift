//
//  EventCard.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//
import SwiftUI

struct EventCardView: View {
    @ObservedObject var viewModel: EventCardViewModel
    @State private var isNavigationActive = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                self.isNavigationActive = true
            }) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.event.eventName)
                        .font(.headline)
                    Text(viewModel.event.eventDescription)
                        .font(.subheadline)
                    Text("Date: \(viewModel.event.eventDate)") // Format the date
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
                    
                    Text("View Event")
                        .foregroundColor(.teal)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(8)
                        .fontWeight(.heavy)
                }
                .padding()
                .background(Color.teal.opacity(0.2))
                .cornerRadius(8)
            }
            .background(
                NavigationLink(destination:
                    destinationView(),
                    isActive: $isNavigationActive) {
                        EmptyView()
                }
            )
        }
    }
    
    private func destinationView() -> some View {
        if viewModel.type == "business" {
            return AnyView(UpdateEventView(event: viewModel.event))
        } else {
            return AnyView(EventFullContextView(viewModel: EventFullContextViewModel(event: viewModel.event)))
        }
    }
}



struct EventCardView_Previews: PreviewProvider {
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
        let viewModel = EventCardViewModel(event: testEvent, isAttending: true, type: "local")
        return EventCardView(viewModel: viewModel)
    }
}
