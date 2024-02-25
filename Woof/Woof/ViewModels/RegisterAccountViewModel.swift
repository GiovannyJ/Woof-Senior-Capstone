//
//  RegisterAccountViewModel.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import Foundation
import SwiftUI

class RegisterAccountViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var email: String = ""
    
    @State public var showAlert = false
    @State public var isRegistered = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    
    func registerUser() {
        // Check if passwords match
        guard password == confirmPassword else {
            DispatchQueue.main.async {
                self.showAlert = true
                self.alertTitle = "Error"
                self.alertMessage = "Passwords do not match"
            }
            return
        }
        
        // Prepare the request body
        let requestBody: [String: Any] = [
            "username": username,
            "password": password,
            "email": email,
            "accountType": "regular"
        ]
        print(requestBody)
        
        // Define the URL
        guard let url = URL(string: "http://localhost:8080/users") else {
            
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert request body to JSON data
        guard let requestBodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
           
            return
        }
        
        // Attach request body to the request
        request.httpBody = requestBodyData
    
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                // Handle network errors
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 201:
                    DispatchQueue.main.async{
                        self.isRegistered = true
                        self.showAlert = true
                        self.alertTitle = "Account Already Exists"
                        self.alertMessage = "An account with this email or username already exists."
                    }
                    // Registration successful, navigate to the login page
                    
                case 400:
                    // Account already exists, display a message to the user
                    self.showAlert = true
                    self.alertTitle = "Account Already Exists"
                    self.alertMessage = "An account with this email or username already exists."
                case 500:
                    // Server error, display a generic error message to the user
                    self.showAlert = true
                    self.alertTitle = "Server Error"
                    self.alertMessage = "An unexpected server error occurred. Please try again later."
                default:
                    self.showAlert = true
                    self.alertTitle = "Error"
                    self.alertMessage = "Unexpected response code: \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }
}
