//
//  UpdateEventsListView.swift
//  Woof
//
//  Created by Giovanny Joseph on 3/6/24.
//
import SwiftUI

struct UpdateEventsListView: View {
    @ObservedObject var viewModel = LocalEventsViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Businesses Events")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()

            // Display a list of events created and promoted by businesses
            ScrollView {
                //MAPVIEW
                ForEach(viewModel.events, id: \.eventID) { event in
                    EventCardView(viewModel: EventCardViewModel(event: event, isAttending: true, type: "business"))
                        .padding(.vertical, 8)
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchEvents(type: "business")
        }
    }
}

struct UpdateEventsListViewPreview: PreviewProvider {
    static var previews: some View {
        UpdateEventsListView()
    }
}
