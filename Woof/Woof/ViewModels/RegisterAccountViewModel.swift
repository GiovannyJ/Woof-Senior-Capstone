//
//  RegisterAccountViewModel.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import Foundation
import SwiftUI
import Combine

class RegisterAccountViewModel: ObservableObject {
    var username: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var email: String = ""
    
    @Published var showAlert = false
    @Published var isRegistered = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    var cancellables = Set<AnyCancellable>()
    
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
            if let error = error {
                // Handle network errors
                print(error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 201:
                    self.isRegistered = true
                    self.showAlert(title: "Success", message: "Registration successful!")
                case 400:
                    // Account already exists, display a message to the user
                    self.showAlert(title: "Account Already Exists", message: "An account with this email or username already exists.")
                case 500:
                    // Server error, display a generic error message to the user
                    self.showAlert(title: "Server Error", message: "An unexpected server error occurred. Please try again later.")
                default:
                    self.showAlert(title: "Error", message: "Unexpected response code: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            self.alertTitle = title
            self.alertMessage = message
            self.showAlert = true
        }
    }
}
