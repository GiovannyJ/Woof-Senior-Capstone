//
//  RegisterAccountView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//
import SwiftUI
import Foundation
import Combine


struct RegisterAccountView: View {
    @ObservedObject private var sessionManager = SessionManager.shared
    @StateObject var viewModel = RegisterAccountViewModel()
    @State private var isAlertShown = false
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        NavigationStack {
            VStack(spacing: 13.0) {
                // Email text field
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.headline)
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .background(Color.teal.opacity(0.2))
                        .cornerRadius(8)
                }
                
                // Username text field
                VStack(alignment: .leading) {
                    Text("Username")
                        .font(.headline)
                    TextField("Username", text: $viewModel.username)
                        .padding()
                        .background(Color.teal.opacity(0.2))
                        .cornerRadius(8)
                }

                // Password secure field
                VStack(alignment: .leading) {
                    Text("Password")
                        .font(.headline)
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color.teal.opacity(0.2))
                        .cornerRadius(8)
                }
                
                // Confirm Password secure field
                VStack(alignment: .leading) {
                    Text("Confirm Password")
                        .font(.headline)
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .padding()
                        .background(Color.teal.opacity(0.2))
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading) {
                    Button(action: {
                        viewModel.selectProfilePicture()
                    }) {
                        HStack {
                            Text("Select Profile Picture")
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

                // Register button
                Button(action: {
                    // Call the method to handle registration
                    viewModel.registerUser()
                }) {
                    Text("Register")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal)
                        .cornerRadius(8)
                        .fontWeight(Font.Weight.heavy)
                }
                .padding(.horizontal)
                
                .navigationTitle("Sign Up")
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")) {
                        if viewModel.alertTitle == "Success"{
                            presentationMode.wrappedValue.dismiss()
                        }
                    })
                }
            }
        }.padding(.horizontal)
        
    }
}


struct RegisterAccountView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterAccountView()
    }
}
