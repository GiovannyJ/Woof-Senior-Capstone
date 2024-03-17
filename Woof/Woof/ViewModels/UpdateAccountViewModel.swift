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
    
    var showAlert = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    @ObservedObject var sessionManager = SessionManager.shared
    
    var didSelectImage: ((UIImage?) -> Void)?
    var imageUploader = ImageUploader()

    
    func uploadProfileImage(completion: @escaping (Result<Int, Error>) -> Void) {
        guard let image = newProfileImage else {
            return
        }
        
        imageUploader.uploadImage(image: image, type: "profile") { result in
            switch result {
            case .success(let imgID):
                completion(.success(imgID))
            case .failure(let error):
                print("Error uploading profile image:", error)
                completion(.failure(error))
            }
        }
    }


    func updateAccount(completion: @escaping (Bool) -> Void) {
        guard let currentUserID = sessionManager.currentUser?.userID else {
            errorMessage = "Failed to update account: Current user ID is missing."
            completion(false)
            return
        }
        
        // Check if a new profile image exists
        if let newProfileImage = newProfileImage {
            // Upload the profile image
            uploadProfileImage { result in
                switch result {
                case .success(let imgID):
                    // Include the imgID in the updateData JSON body
                    var updateData: [String: Any] = [
                        "tablename": "user",
                        "columns_old": ["userID"],
                        "values_old": [currentUserID],
                        "columns_new": ["username", "email", "imgID"],
                        "values_new": [self.newUsername, self.newEmail, imgID]
                    ]
                    
                    // Perform the PATCH request
                    self.performPatchRequest(with: updateData, userID: currentUserID, completion: completion)
                case .failure(let error):
                    print("Error uploading profile image:", error)
                    completion(false)
                }
            }
        } else {
            // No new profile image, perform the PATCH request directly
            var updateData: [String: Any] = [
                "tablename": "user",
                "columns_old": ["userID"],
                "values_old": [currentUserID],
                "columns_new": [],
                "values_new": []
            ]
            
            // Conditionally add username to the JSON body
            if !newUsername.isEmpty {
                updateData["columns_new"] = (updateData["columns_new"] as? [String] ?? []) + ["username"]
                updateData["values_new"] = (updateData["values_new"] as? [String] ?? []) + [newUsername]
            }

            // Conditionally add email to the JSON body
            if !newEmail.isEmpty {
                updateData["columns_new"] = (updateData["columns_new"] as? [String] ?? []) + ["email"]
                updateData["values_new"] = (updateData["values_new"] as? [String] ?? []) + [newEmail]
            }

            // Perform the PATCH request
            performPatchRequest(with: updateData, userID: currentUserID, completion: completion)
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
                        self.sessionManager.fetchProfileImage()
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
    
    func performPatchRequest(with updateData: [String: Any], userID: Int, completion: @escaping (Bool) -> Void) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: updateData)
            // Prepare the URL for the update request
            guard let url = URL(string: "http://localhost:8080/users") else {
                errorMessage = "Invalid URL"
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            // Prepare the URL request
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Perform the request
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, let data = data, error == nil else {
                    let errorMessage = "Error: \(error?.localizedDescription ?? "Unknown error")"
                    DispatchQueue.main.async {
                        self.errorMessage = errorMessage
                        completion(false)
                    }
                    return
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    // Success
                    DispatchQueue.main.async {
                        self.showAlert(title: "Success", message: "Profile updated successfully")
                    }
                    self.fetchUpdatedUserInfo(userID: userID) { success in
                        DispatchQueue.main.async {
                            completion(success)
                        }
                    }
                default:
                    // Failure
                    let errorMessage = "Error: \(httpResponse.statusCode)"
                    DispatchQueue.main.async {
                        self.errorMessage = errorMessage
                        self.showAlert(title: "Failed", message: "Profile update failed")
                        completion(false)
                    }
                }
            }.resume()
        } catch {
            let errorMessage = "Error encoding JSON data: \(error)"
            DispatchQueue.main.async {
                self.errorMessage = errorMessage
                completion(false)
            }
        }
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
                    self.showAlert(title: "Success", message: "Password updated successfully")
                } else {
                    // Password update failed
                    self.errorMessage = "Password update failed"
                    self.showAlert(title: "Failed", message: "Password update failed")
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
    
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            self.alertTitle = title
            self.alertMessage = message
            self.showAlert = true
        }
    }
}
