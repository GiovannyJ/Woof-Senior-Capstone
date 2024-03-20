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
    @State private var isAlertShown = false
    @State private var navigateToHome = false
    @Environment(\.presentationMode) var presentationMode
    
    let businessTypes = ["All", "Arts & Entertainment", "Active Life", "Hotels & Travel", "Local Flavor", "Restaurants", "Shopping", "Other"]
    
    init(){
        viewModel = RegisterBusinessViewModel()
    }
    
    
    var body: some View {
            VStack {
                Form {
                    Section(header: Text("Business Details")
                        .foregroundColor(.teal)
                        .font(.title)
                        .padding(.vertical)
                        .fontWeight(.bold)) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Business Name")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                TextField("Business Name", text: $viewModel.businessName)
                                    .padding()
                                    .background(Color.teal.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Business Type")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Picker("Business Type", selection: $viewModel.businessType) {
                                    ForEach(businessTypes, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding()
                                .background(Color.teal.opacity(0.2))
                                .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Location")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                TextField("Location", text: $viewModel.location)
                                    .padding()
                                    .background(Color.teal.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Contact")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                TextField("Contact", text: $viewModel.contact)
                                    .padding()
                                    .background(Color.teal.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                        .cornerRadius(4)
                        .padding(.vertical, 5)
                
                Section(header: Text("Additional Information").foregroundColor(.teal)
                    .font(.headline)
                    .padding(.vertical)
                    .fontWeight(.medium)) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Description")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("Description", text: $viewModel.description)
                                .padding()
                                .background(Color.teal.opacity(0.2))
                                .cornerRadius(8)
                        }
                        
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
                        
                        VStack(alignment: .leading) {
                            Button(action: {
                                viewModel.selectBusinessPicture()
                            }) {
                                HStack {
                                    Text("Select Business Picture")
                                    if let newProfileImage = viewModel.newBusinessImage {
                                        Image(uiImage: newProfileImage)
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .clipShape(Circle())
                                    }
                                }
                                .padding()
                                .background(Color.teal.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                            .padding()
                            .sheet(isPresented: $viewModel.isShowingImagePicker) {
                                ImagePicker(image: $viewModel.newBusinessImage, isPresented: $viewModel.isShowingImagePicker, didSelectImage: viewModel.imagePickerDidSelectImage)
                            }
                        }
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
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")) {
                presentationMode.wrappedValue.dismiss() 
            })
        }
    }
}

struct RegisterBusinessView_Preview: PreviewProvider {
    static var previews: some View {
        RegisterBusinessView()
    }
}
