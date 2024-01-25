//  LocalEventsView.swift
//  Woof
//
//  Created by Bo Nappie on 1/23/24.
//

import SwiftUI

struct LocalEvents: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pet-Friendly Events Near You")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()

            // Display a list of events created and promoted by businesses
            ScrollView {
                ForEach(FakeData.businessEvents, id: \.id) { businessEvent in
                    BusinessEventCard(businessEvent: businessEvent)
                        .padding(.vertical, 8)
                }
            }
        }
        .padding()
        .navigationTitle("Local Events")
    }
}

struct LocalEvents_Previews: PreviewProvider {
    static var previews: some View {
        LocalEvents()
    }
}

// Fake data for testing
struct BusinessEvent: Identifiable {
    let id: Int
    let businessName: String
    let eventName: String
    let eventDescription: String
    let eventDate: String
    let location: String
    let contactInfo: String
}

struct FakeData {
    static let businessEvents: [BusinessEvent] = [
        BusinessEvent(id: 1, businessName: "Pier2 Kitchen and Cocktails", eventName: "Grand Opening Celebration", eventDescription: "Join us on the Pier with your furry friends for the grand opening of Pier2 Kitchen and Cocktails!", eventDate: "February 15, 2024", location: "Pier 2, SAILville", contactInfo: "info@Pier2KNC.com"),
        BusinessEvent(id: 2, businessName: "Bark & Brewery", eventName: "Yappy Hour", eventDescription: "Bring your furry friends for a yappy hour at Bark &  Brewery!", eventDate: "February 20, 2024", location: "456 Oak St,  Pupville", contactInfo: "events@barknbrewery.com"),
            // 2 examples
    ]
}

// BusinessEventCard 
struct BusinessEventCard: View {
    let businessEvent: BusinessEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(businessEvent.businessName)
                .font(.headline)
            Text(businessEvent.eventName)
                .font(.subheadline)
            Text(businessEvent.eventDescription)
                .font(.subheadline)
            Text("Date: \(businessEvent.eventDate)")
            Text("Location: \(businessEvent.location)")
            Text("Contact: \(businessEvent.contactInfo)")
        }
        .padding()
        .background(Color.teal.opacity(0.2))
        .cornerRadius(8)
    }
}
