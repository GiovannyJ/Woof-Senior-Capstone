//
//  updateEvent.swift
//  Woof
//
//  Created by Bo Nappie on 3/4/24.
//

import SwiftUI

struct UpdateEventView: View {
    @State private var eventName: String = ""
    @State private var eventDescription: String = ""
    @State private var eventDate: Date = Date()
    @State private var location: String = ""
    @State private var contactInfo: String = ""
    @State private var petSizePref: String = ""
    @State private var leashPolicy: String = ""
    @State private var disabledFriendly: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Update Your Pet-Friendly Event")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()
                
            
            // input event details
            Form {
                Section(header: Text("Event Information")){
                    TextField("Event Name", text: $eventName)
                    TextField("Event Description", text: $eventDescription)
                    DatePicker("Event Date", selection: $eventDate, displayedComponents: .date)
                    TextField("Location", text: $location)
                    TextField("Contact Information", text: $contactInfo)
                    TextField("Leash Policy", text: $leashPolicy)
                    Toggle("Disabled Friendly", isOn: $disabledFriendly)
                    
                    Picker("Pet Size Preference", selection: $petSizePref) {
                        Text("Small Pets").tag("small")
                        Text("Medium Pets").tag("medium")
                        Text("Large Pets").tag("large")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            
                //submit the event update
                Section {
                    Button(action: {
                        updateEvent()
                    }) {
                        Text("Update Event")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange.opacity(0.8))
                            .cornerRadius(8)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Update Event")
        .background(Color.orange.opacity(0.2))
    }
    
    // update the event
    private func updateEvent() {
        // code for updating the event here...
      
    }
}

struct UpdateEventView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateEventView()
    }
}
