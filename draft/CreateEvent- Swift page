//  CreateEventView.swift
//  Woof
//
//  Created by Bo Nappie on 1/23/24.
//

import SwiftUI

struct CreateEventView: View {
    // Variables to store user input for event details
    @State private var eventName: String = ""
    @State private var eventDescription: String = ""
    @State private var eventDate: String = ""
    @State private var location: String = ""
    @State private var contactInfo: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Promote Your Pet-Friendly Event")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()

            // Form to input event details
            Form {
                Section(header: Text("Event Information")) {
                    TextField("Event Name", text: $eventName)
                    TextField("Event Description", text: $eventDescription)
                    TextField("Event Date", text: $eventDate)
                    TextField("Location", text: $location)
                    TextField("Contact Information", text: $contactInfo)
                }

                // Button to submit the event
                Section {
                    Button(action: {
                        // No real action rn
                        submitEvent()
                    }) {
                        Text("Submit Event")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.teal)
                            .cornerRadius(8)
                            .fontWeight(Font.Weight.heavy)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Create Event")
    }

    // Function for event submission
    private func submitEvent() {
        //  logic to submit the event to the database
        print("Event created successfully!")
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView()
    }
}
