//
//  LocalEventsView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct LocalEventsView: View {
    @ObservedObject var viewModel = LocalEventsViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pet-Friendly Events Near You")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()

            // Display a list of events created and promoted by businesses
            ScrollView {
                //MAPVIEW
                ForEach(viewModel.events, id: \.eventID) { event in
                    EventCard(event: event)
                        .padding(.vertical, 8)
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchEvents()
        }
        .navigationTitle("Local Events")
    }
}

struct LocalEvents_Previews: PreviewProvider {
    static var previews: some View {
        LocalEventsView()
    }
}
