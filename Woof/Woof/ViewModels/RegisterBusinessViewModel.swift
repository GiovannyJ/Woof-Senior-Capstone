//
//  RegisterBusinessViewModel.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import Foundation
import SwiftUI

class RegisterBusinessViewModel: ObservableObject{
    @Published  var businessName: String = ""
    @Published  var businessType: String = "Other"
    @Published  var location: String = ""
    @Published  var contact: String = ""
    @Published  var description: String = ""
    @Published  var events: String = ""
    @Published  var petSizePref: String = "small" // Default value
    @Published  var leashPolicy: Bool = true
    @Published  var disabledFriendly: Bool = false
    @Published var registrationStatus: String = ""
    
    @Published var newBusinessImage: UIImage?
    @Published var isShowingImagePicker = false
    
    var didSelectImage: ((UIImage?) -> Void)?
    var imageUploader = ImageUploader()
    
    @ObservedObject  var sessionManager = SessionManager.shared
    
    private var ownerUserID: Int = SessionManager.shared.currentUser?.userID ?? 0
    
    public func registerBusiness() {
        let businessData: [String: Any] = [
            "businessName": businessName,
            "businessType": businessType,
            "ownerUserID": ownerUserID,
            "location": location,
            "contact": contact,
            "description": description,
            "petSizePref": petSizePref,
            "leashPolicy": leashPolicy,
            "disabledFriendly": disabledFriendly,
            "dataLocation": "internal",
        ]
        print(businessData)
        
        // JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: businessData) else {
            print("Error converting data to JSON")
            return
        }
        
        guard let url = URL(string: "http://localhost:8080/businesses") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 201:
                    // Successful response
                    print("Business Registered!")
                    // Update SessionManager on the main thread
                    SessionManager.shared.checkUserBusinessOwner()
                    self.uploadProfileImage()
                case 500:
                    // Handle 500 error
                    print("Error: \(httpResponse.statusCode)")
                default:
                    // Handle other status codes
                    print("Unexpected error occurred")
                }
            }
        }.resume()
    }
    
    func uploadProfileImage() {
        guard let image = newBusinessImage else {
            return
        }
        imageUploader.uploadImage(image: image, type: "business") { result in
            switch result {
            case .success(let imgID):
                self.updateBusinessWithImageID(imgID)
            case .failure(let error):
                print("Error uploading profile image:", error)
            }
        }
    }

    private func updateBusinessWithImageID(_ imgID: Int) {
        // Define the URL for updating the user's profile
        guard let updateUserURL = URL(string: "http://localhost:8080/businesses") else {
            return
        }
        
        // Prepare the request body
        let requestBody: [String: Any] = [
            "tablename": "businesses",
            "columns_old": ["businessID"],
            "values_old": [SessionManager.shared.ownedBusiness?.businessID],
            "columns_new": ["imgID"],
            "values_new": [imgID]
        ]
        
        // Create the request
        var request = URLRequest(url: updateUserURL)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert the request body to JSON data
        guard let requestBodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            return
        }
        
        // Attach the request body to the request
        request.httpBody = requestBodyData
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Handle network errors
                print("Error updating profile with image ID: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Profile updated successfully with image ID \(imgID)")
                } else {
                    print("Failed to update profile with image ID \(imgID): HTTP status code \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    func selectBusinessPicture() {
        isShowingImagePicker = true
    }

    func imagePickerDidSelectImage(_ image: UIImage?) {
        newBusinessImage = image
        isShowingImagePicker = false
        didSelectImage?(image)
    }
}

