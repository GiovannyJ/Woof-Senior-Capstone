//
//  LocalEventsView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct LocalEventsView: View {
    @ObservedObject var viewModel = LocalEventsViewModel()
    @ObservedObject var sessionManager = SessionManager.shared
    
    var body: some View {
        ZStack {
            // Background image
            Image("Image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                VStack(spacing: 16) {
                    Spacer()
                    Text("Pet-Friendly Events Near You.")
                        .font(.title)
                        .foregroundColor(.orange)
                        .padding(.horizontal)
                        .frame(maxWidth: geometry.size.width) // Set maximum width
                    
                    ScrollView {
                        // MAPVIEW
                        ForEach(viewModel.events, id: \.eventID) { event in
                            EventCardView(viewModel: EventCardViewModel(event: event, isAttending: self.isAttending(for: event), type: self.eventType(for: event)))
                                .padding(.vertical, 8)
                        }
                    }
                }
                .padding()
                .onAppear {
                    viewModel.fetchEvents(type: "local")
                }
                
                .navigationTitle("Local Events")
            }
        }
    }
    
    private func eventType(for event: Event) -> String {
        if let currentUser = sessionManager.currentUser,
           let eventsAttending = sessionManager.eventsAttending,
           eventsAttending.contains(where: { $0.eventID == event.eventID }) {
            return "disabled"
        } else {
            return "local"
        }
    }
    
    private func isAttending(for event: Event) -> Bool {
        guard let eventsAttending = sessionManager.eventsAttending else {
            return false
        }
        return eventsAttending.contains(where: { $0.eventID == event.eventID })
    }
}

struct LocalEvents_Previews: PreviewProvider {
    static var previews: some View {
        LocalEventsView()
    }
}
