//
//  updateBusiness.swift
//  Woof
//
//  Created by Bo Nappie on 3/4/24.
//

import SwiftUI

struct UpdateBusinessView: View {
    @ObservedObject var viewModel: UpdateBusinessViewModel
    @ObservedObject private var sessionManager = SessionManager.shared
    
    init() {
        self.viewModel = UpdateBusinessViewModel()
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Update Business Details")
                            .foregroundColor(.orange)
                            .font(.title)
                            .padding(.vertical)
                            .fontWeight(.regular)) {
                    TextField("Business Name", text: $viewModel.businessName)
                        .padding()
                        .background(Color.teal.opacity(0.2))
                        .cornerRadius(8)
                    Picker("Business Type", selection: $viewModel.businessType) {
                        ForEach(viewModel.businessTypes, id: \.self) { type in
                            Text(type)
                                .tag(type)
                                .foregroundColor(.gray)
                        }
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
                    TextField("Leash Policy", text: $viewModel.leashPolicy)
                        .padding()
                        .background(Color.teal.opacity(0.2))
                        .cornerRadius(8)
                    TextField("Disabled Pet Friendly", text: $viewModel.disabledFriendly)
                        .padding()
                        .background(Color.teal.opacity(0.2))
                        .cornerRadius(8)
                    Picker("Pet Size Preference", selection: $viewModel.petSizePreference) {
                        ForEach(viewModel.petSizePreferences, id: \.self) { size in
                            Text(size)
                                .tag(size)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .cornerRadius(10)
                .padding(.vertical, 5)
            }
            
            Button(action: {
                viewModel.updateBusiness()
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
            
            Text(viewModel.updateStatus)
                .padding()
                .foregroundColor(.red)
        }
        .padding()
        .background(Color.orange.opacity(0.2))
    }
}

struct UpdateBusinessView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateBusinessView()
    }
}
