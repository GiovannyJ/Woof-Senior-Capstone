//  RegisterView.swift
//  Woof
//
//  Created by Bo Nappie on 1/5/24.
//

import SwiftUI

struct RegisterView: View {
    // variables to store user input for registration
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var Cpassword: String = ""
    @State private var email: String = ""
    @State private var accountType: String = ""
    @State private var showAlert = false
    @State private var isRegistered = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @ObservedObject private var sessionManager = SessionManager.shared

    // Method to handle registration
    private func registerUser() {
        // Check if passwords match
        guard password == Cpassword else {
            // Passwords don't match, show an alert or some indication to the user
            showAlert = true
            alertTitle = "Error"
            alertMessage = "Passwords don't match"
            return
        }

        // Prepare the request body
        let requestBody: [String: Any] = [
            "username": username,
            "password": password,
            "email": email,
            "accountType": accountType
        ]

        // Define the URL
        guard let url = URL(string: "http://localhost:8080/users") else {
            showAlert = true
            alertTitle = "Error"
            alertMessage = "Invalid URL"
            return
        }

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Convert request body to JSON data
        guard let requestBodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            showAlert = true
            alertTitle = "Error"
            alertMessage = "Failed to serialize request body"
            return
        }

        // Attach request body to the request
        request.httpBody = requestBodyData

        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Handle network errors
                showAlert = true
                alertTitle = "Error"
                alertMessage = error.localizedDescription
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 201:
                    isRegistered =  true
                    // Registration successful, navigate to the login page
                    
                case 400:
                    // Account already exists, display a message to the user
                    showAlert = true
                    alertTitle = "Account Already Exists"
                    alertMessage = "An account with this email or username already exists."
                case 500:
                    // Server error, display a generic error message to the user
                    showAlert = true
                    alertTitle = "Server Error"
                    alertMessage = "An unexpected server error occurred. Please try again later."
                default:
                    showAlert = true
                    alertTitle = "Error"
                    alertMessage = "Unexpected response code: \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Email text field
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.headline)
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.teal.opacity(0.2))
                        .cornerRadius(8)
                }
                
                // Username text field
                VStack(alignment: .leading) {
                    Text("Username")
                        .font(.headline)
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.teal.opacity(0.2))
                        .cornerRadius(8)
                }

                // Password secure field
                VStack(alignment: .leading) {
                    Text("Password")
                        .font(.headline)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.teal.opacity(0.2))
                        .cornerRadius(8)
                }
                
                // Confirm Password secure field
                VStack(alignment: .leading) {
                    Text("Confirm Password")
                        .font(.headline)
                    SecureField("Confirm Password", text: $Cpassword)
                        .padding()
                        .background(Color.teal.opacity(0.2))
                        .cornerRadius(8)
                }

                // Register button
                Button(action: {
                    // Call the method to handle registration
                    registerUser()
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
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .navigationDestination(
                    isPresented: $isRegistered){
                        Login()
                    }
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
