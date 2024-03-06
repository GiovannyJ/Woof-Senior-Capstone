//
//  updateBusiness.swift
//  Woof
//
//  Created by Bo Nappie on 3/4/24.
//

import SwiftUI

struct UpdateBusinessView: View {
    @State private var businessName: String = ""
    @State private var businessType: String = ""
    @State private var location: String = ""
    @State private var contact: String = ""
    @State private var description: String = ""
    @State private var events: String = ""
    @State private var petSizePreference: String = "small"
    @State private var leashPolicy: String = ""
    @State private var disabledFriendly: String = ""
    
    @State private var updateStatus: String = ""
    @ObservedObject private var sessionManager = SessionManager.shared
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Update Business Details")
                    .foregroundColor(.orange)
                    .font(.title)
                    .padding(.vertical)
                    .fontWeight(.regular)) {
                        TextField("Business Name", text: $businessName)
                            .padding()
                            .background(Color.teal.opacity(0.2))
                            .cornerRadius(8)
                        Picker("Business Type", selection: $businessType) {
                            Text("Arts & Entertainment").tag("T1")
                                .foregroundColor(.gray)
                            Text("Active Life").tag("T2")
                                .foregroundColor(.gray)
                            Text("Hotels & Travel").tag("T3")
                            Text("Local Flavor").tag("T5")
                            Text("Restaurants").tag("T6")
                            Text("Shopping").tag("T7")
                            Text("Other").tag("T8")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color.teal.opacity(0.2))
                        .cornerRadius(8)
                        TextField("Location", text: $location)
                            .padding()
                            .background(Color.teal.opacity(0.2))
                            .cornerRadius(8)
                        TextField("Contact", text: $contact)
                            .padding()
                            .background(Color.teal.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .cornerRadius(4)
                    .padding(.vertical, 5)
                
                Section(header: Text("Additional Information").foregroundColor(.teal)
                    .font(.headline)
                    .padding(.vertical)
                    .fontWeight(.medium)) {
                        TextField("Description", text: $description)
                            .padding()
                            .background(Color.teal.opacity(0.2))
                            .cornerRadius(8)
                        TextField("Leash Policy", text: $leashPolicy)
                            .padding()
                            .background(Color.teal.opacity(0.2))
                            .cornerRadius(8)
                        TextField("Disabled Pet Friendly", text: $disabledFriendly)
                            .padding()
                            .background(Color.teal.opacity(0.2))
                            .cornerRadius(8)
                        Picker("Pet Size Preference", selection: $petSizePreference) {
                            Text("Small Pets").tag("small")
                            Text("Medium Pets").tag("medium")
                            Text("Large Pets").tag("large")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .cornerRadius(10)
                    .padding(.vertical, 5)
            }
            
            Button(action: {
                updateBusiness()
            }) {
                Text("Update Business")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.8))
                    .cornerRadius(8)
                    .font(.headline)
            }
            .padding(.vertical)
            .buttonStyle(PlainButtonStyle())
            
            Text(updateStatus)
                .padding()
                .foregroundColor(.red)
        }
        .padding()
        .background(Color.orange.opacity(0.2))
    }
    
    private func updateBusiness() {
        // Update business logic here
    }
}

struct UpdateBusiness_Previews: PreviewProvider {
    static var previews: some View {
        UpdateBusinessView()
    }
}

