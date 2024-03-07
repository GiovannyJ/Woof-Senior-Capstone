//
//  LoginViewModel.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//
import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    @Published var navigateToHome: Bool = false // New property for navigation

    func authenticateUser() {
        let url = URL(string: "http://localhost:8080/login")!
        
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            errorMessage = "Failed to serialize request body"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                    // Successful response
                    do {
                        let decodedData = try JSONDecoder().decode([User].self, from: data!)
                        guard let user = decodedData.first else {
                            DispatchQueue.main.async {
                                self.errorMessage = "Invalid user data"
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            SessionManager.shared.currentUser = user
                            SessionManager.shared.userID = user.userID
                            SessionManager.shared.isLoggedIn = true
                            SessionManager.shared.checkUserBusinessOwner()
                            SessionManager.shared.fetchEventsAttending()
                            self.isLoggedIn = true
                            self.navigateToHome = true // Set to true to trigger navigation
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.errorMessage = "Error decoding JSON: \(error.localizedDescription)"
                        }
                    }
                case 500:
                    // Handle 500 error
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data!)
                        DispatchQueue.main.async {
                            self.errorMessage = errorResponse.error
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.errorMessage = "Internal Server Error"
                        }
                    }
                default:
                    // Handle other status codes
                    DispatchQueue.main.async {
                        self.errorMessage = "Unexpected error occurred"
                    }
                }
            }
        }.resume()
    }
}

