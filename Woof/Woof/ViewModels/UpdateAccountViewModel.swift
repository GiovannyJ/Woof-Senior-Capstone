//
//  UpdateAccountViewModel.swift
//  Woof
//
//  Created by Giovanny Joseph on 3/4/24.
//

import Foundation
import SwiftUI

class UpdateAccountViewModel: ObservableObject {
    @Published var newUsername: String = ""
    @Published var newEmail: String = ""
    @Published var oldPassword: String = ""
    @Published var newPassword: String = ""
    @Published var newProfileImage: UIImage?
    @Published var errorMessage: String?
    @Published var isShowingImagePicker = false
    @ObservedObject var sessionManager = SessionManager.shared

    var didSelectImage: ((UIImage?) -> Void)?

    func updateAccount(completion: @escaping (Bool) -> Void) {
        guard let currentUserID = sessionManager.currentUser?.userID else {
            errorMessage = "Failed to update account: Current user ID is missing."
            completion(false)
            return
        }
        
        // Construct the URL for the update request
        guard let url = URL(string: "http://localhost:8080/users") else {
            errorMessage = "Invalid URL"
            completion(false)
            return
        }
        
        // Prepare the JSON body
        var updateData: [String: Any] = [
            "tablename": "user",
            "columns_old": ["userid"],
            "values_old": [currentUserID]
        ]
        
        // Conditionally add username to the JSON body
        if !newUsername.isEmpty {
            updateData["columns_new"] = ["username"]
            updateData["values_new"] = [newUsername]
        }

        // Conditionally add email to the JSON body
        if !newEmail.isEmpty {
            if let columns = updateData["columns_new"] as? [String], let values = updateData["values_new"] as? [String] {
                updateData["columns_new"] = columns + ["email"]
                updateData["values_new"] = values + [newEmail]
            } else {
                updateData["columns_new"] = ["email"]
                updateData["values_new"] = [newEmail]
            }
        }

        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: updateData)
            // Prepare the URL request
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Perform the request
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    self.errorMessage = "Error: \(error?.localizedDescription ?? "Unknown error")"
                    completion(false)
                    return
                }
                
                // Parse the response
                self.fetchUpdatedUserInfo(userID: currentUserID) { success in
                    completion(success)
                }
            }.resume()
        } catch {
            errorMessage = "Error encoding JSON data: \(error)"
            completion(false)
        }
    }


    func fetchUpdatedUserInfo(userID: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://localhost:8080/users?userID=\(userID)") else {
            errorMessage = "Invalid URL"
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    self.errorMessage = "Error: \(error?.localizedDescription ?? "Unknown error")"
                    completion(false)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let updatedUsers = try decoder.decode([User].self, from: data)
                    
                    // Assuming the response contains only one user with the specified ID
                    if let updatedUser = updatedUsers.first {
                        // Update the session manager's current user
                        self.sessionManager.currentUser = updatedUser
                        completion(true)
                    } else {
                        self.errorMessage = "No user found with the specified ID"
                        completion(false)
                    }
                } catch {
                    self.errorMessage = "Error decoding JSON response: \(error)"
                    completion(false)
                }
            }
        }.resume()
    }


    func updatePassword(completion: @escaping () -> Void) {
        guard let currentUserID = sessionManager.currentUser?.userID else {
            errorMessage = "Failed to update password: Current user ID is missing."
            return
        }
        
        // Construct the URL for the password update request
        guard let url = URL(string: "http://localhost:8080/users/password") else {
            errorMessage = "Invalid URL"
            return
        }
        
        // Prepare the JSON body
        let updateData: [String: Any] = [
            "userID": currentUserID,
            "oldpwd": oldPassword,
            "newpwd": newPassword
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: updateData)
            // Prepare the URL request
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Perform the request
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Invalid response"
                    completion()
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    // Password updated successfully
                    self.errorMessage = "Password updated successfully"
                } else {
                    // Password update failed
                    self.errorMessage = "Password update failed"
                }
                
                DispatchQueue.main.async {
                    // Show a popup with the message
                    // You can implement your own popup logic here
                    // For simplicity, I'll just print the message
                    print(self.errorMessage ?? "")
                    completion()
                }
            }.resume()
        } catch {
            errorMessage = "Error encoding JSON data: \(error)"
            completion()
        }
    }




    func selectProfilePicture() {
        isShowingImagePicker = true
    }

    func imagePickerDidSelectImage(_ image: UIImage?) {
        newProfileImage = image
        isShowingImagePicker = false
        didSelectImage?(image)
    }
}
