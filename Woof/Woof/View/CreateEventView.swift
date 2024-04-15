//
//  CreateEventView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct CreateEventView: View {
    @ObservedObject private var viewModel = CreateEventViewModel()
    @State private var isAlertShown = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16){
                Text("Create A Pet-Friendly Event")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                    .padding()
                Form {
                    Section(header: Text("Event Information")) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Event Name")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("Event Name", text: $viewModel.eventName)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Event Description")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("Event Description", text: $viewModel.eventDescription)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Date")
                                .font(.caption)
                                .foregroundColor(.gray)
                            DatePicker("Date", selection: $viewModel.eventDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(.compact)
                                .foregroundColor(.gray)
                                .padding()
                                .cornerRadius(8)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Location")
                                .font(.caption)
                                .foregroundColor(.gray)
                            AddressAutocompleteTextField(text: $viewModel.location)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Contact Information")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("Contact Information", text: $viewModel.contactInfo)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Leash Policy")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Toggle("Leash Policy", isOn: $viewModel.leashPolicy)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Disabled Friendly")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Toggle("Disabled Friendly", isOn: $viewModel.disabledFriendly)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Pet Size Preference")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Picker("Pet Size Preference", selection: $viewModel.petSizePref) {
                                Text("Small Pets").tag("small")
                                Text("Medium Pets").tag("medium")
                                Text("Large Pets").tag("large")
                            }
                            .padding()
                            .cornerRadius(8)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Event Picture")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Button(action: {
                                viewModel.selectEventPicture()
                            }) {
                                HStack {
                                    Text("Select Event Picture")
                                    if let newProfileImage = viewModel.newProfileImage {
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
                                ImagePicker(image: $viewModel.newProfileImage, isPresented: $viewModel.isShowingImagePicker, didSelectImage: viewModel.imagePickerDidSelectImage)
                            }
                        }
                        Button(action: {
                            viewModel.submitEvent() { success in
                                if success {
                                    // Event submitted successfully, perform any necessary actions
                                    // For example, navigate to another view
                                } else {
                                    // Handle submission failure
                                }
                            }
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
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }
}


struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView()
    }
}

