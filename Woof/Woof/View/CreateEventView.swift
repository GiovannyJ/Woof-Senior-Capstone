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
            VStack{
                Form {
                    Section(header: Text("Event Information")) {
                        TextField("Event Name", text: $viewModel.eventName)
                        TextField("Event Description", text: $viewModel.eventDescription)
                        DatePicker("Date", selection: $viewModel.eventDate, in: Date()..., displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .foregroundColor(.gray)
                            .padding()
                            .cornerRadius(8)
                        TextField("Location", text: $viewModel.location)
                        TextField("Contact Information", text: $viewModel.contactInfo)
                        Toggle("Leash Policy", isOn: $viewModel.leashPolicy)
                        Toggle("Disabled Friendly", isOn: $viewModel.disabledFriendly)
                        Picker("Pet Size Preference", selection: $viewModel.petSizePref) {
                            Text("Small Pets").tag("small")
                            Text("Medium Pets").tag("medium")
                            Text("Large Pets").tag("large")
                        }
                        .padding()
                        .cornerRadius(8)
                        VStack(alignment: .leading) {
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
                    }
                    
                    
                    // Button to submit the event
                    Section {
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
        }
            .navigationTitle("Create Event")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView()
    }
}

