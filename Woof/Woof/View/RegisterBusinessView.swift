//
//  RegisterBusinessView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct RegisterBusinessView: View {
    @ObservedObject private var sessionManager = SessionManager.shared
    @ObservedObject var viewModel: RegisterBusinessViewModel
    
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Business Details")
                    .foregroundColor(.teal)
                    .font(.title)
                    .padding(.vertical)
                    .fontWeight(.bold)) {
                        TextField("Business Name", text: $viewModel.businessName)
                            .padding()
                            .background(Color.teal.opacity(0.2))
                            .cornerRadius(8)
                        Picker("Business Type", selection: $viewModel.businessType) {
                            Text("Arts & Entertainment").tag("Arts & Entertainment")
                                .foregroundColor(.gray)
                            Text("Active Life").tag("Active Life")
                                .foregroundColor(.gray)
                            Text("Hotels & Travel").tag("Hotels & Travel")
                            Text("Local Flavor").tag("Local Flavor")
                            Text("Restaurants").tag("Restaurants")
                            Text("Shopping").tag("Shopping")
                            Text("Other").tag("Other")
                        }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .background(Color.teal.opacity(0.2))
                            .cornerRadius(8)
                        TextField("Location", text: $viewModel.location)
                            .padding()
                            .background(Color.teal.opacity(0.2))
                            .cornerRadius(8)
                        TextField("Contact", text: $viewModel.contact)
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
                        TextField("Description", text: $viewModel.description)
                            .padding()
                            .background(Color.teal.opacity(0.2))
                            .cornerRadius(8)
                        Picker("Leash Policy", selection: $viewModel.leashPolicy){
                            Text("Yes").tag(true)
                            Text("No").tag(false)
                        }
                        .padding()
                        .cornerRadius(8)
                        
                        Picker("Disabled Pet Friendly", selection: $viewModel.disabledFriendly){
                            Text("Yes").tag(true)
                            Text("No").tag(false)
                        }
                        .padding()
                        .cornerRadius(8)
                        
                        Picker("Pet Size Preference", selection: $viewModel.petSizePref) {
                            Text("Small Pets").tag("small")
                            Text("Medium Pets").tag("medium")
                            Text("Large Pets").tag("large")
                        }
                        .padding()
                        .cornerRadius(8)
                    }
                    .cornerRadius(10)
                    .padding(.vertical, 5)
            }
            
            Button(action: {
                viewModel.registerBusiness()
            }) {
                Text("Register Business")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.teal)
                    .cornerRadius(8)
                    .font(.headline)
            }
            .padding(.vertical)
            .buttonStyle(PlainButtonStyle())
            
            Text(viewModel.registrationStatus)
                .padding()
                .foregroundColor(.red)
        }
        .padding()
    }
}

struct RegisterBusinessView_Preview: PreviewProvider {
    static var previews: some View {
        RegisterBusinessView(viewModel: RegisterBusinessViewModel())
    }
}
