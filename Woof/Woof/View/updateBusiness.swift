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
    @Environment(\.presentationMode) private var presentationMode
    @State private var isAlertShown = false
    
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
                        Toggle("Leash Policy", isOn: $viewModel.leashPolicy)
                        Toggle("Disabled Friendly", isOn: $viewModel.disabledFriendly)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Pet Size Preference")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Picker("Pet Size Preference", selection: $viewModel.petSizePreference) {
                                ForEach(viewModel.petSizePreferences, id: \.self) { size in
                                    Text(size)
                                        .tag(size)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        if let businessImage = SessionManager.shared.businessImage {
                            Image(uiImage: businessImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                        }
                        Button(action: {
                            viewModel.selectBusinessPicture()
                        }) {
                            HStack {
                                Text("Change Profile Picture")
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
                        
                        //delete business button
                        Button(action: viewModel.deleteBusiness) {
                            Text("Delete Event")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                            .frame(maxWidth: .infinity)
                        
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
            
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")) {
                if viewModel.alertTitle == "Business Deleted"{
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}

struct UpdateBusinessView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateBusinessView()
    }
}
