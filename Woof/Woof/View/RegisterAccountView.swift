//
//  RegisterAccountView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct RegisterAccountView: View {
    @ObservedObject private var sessionManager = SessionManager.shared
    @StateObject var viewModel = RegisterAccountViewModel()


    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
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

                .padding()
                .navigationTitle("Register")
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
                .navigationDestination(
                    isPresented: $viewModel.isRegistered){
                        LoginView()
                    }
            }
        }
    }
}

struct RegisterAccountView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterAccountView()
    }
}
