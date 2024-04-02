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
    @Published  var petSizePref: String = "small"
    @Published  var leashPolicy: Bool = true
    @Published  var disabledFriendly: Bool = false
    @Published  var registrationStatus: String = ""
    
    @Published var newBusinessImage: UIImage?
    @Published var isShowingImagePicker = false
    var showAlert = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    var didSelectImage: ((UIImage?) -> Void)?
    var imageUploader = ImageUploader()
    
    @ObservedObject  var sessionManager = SessionManager.shared
    
    private var ownerUserID: Int = SessionManager.shared.currentUser?.userID ?? 0
    
    public func registerBusiness() {
        // Perform forward geocoding to get the location coordinates
        ForwardGeocoding(address: location) { result in
            switch result {
            case .success(let geolocation):
                // If forward geocoding succeeds, proceed with registering the business
                let businessData: [String: Any] = [
                    "businessName": self.businessName,
                    "businessType": self.businessType,
                    "ownerUserID": self.ownerUserID,
                    "location": self.location,
                    "contact": self.contact,
                    "description": self.description,
                    "petSizePref": self.petSizePref,
                    "leashPolicy": self.leashPolicy,
                    "disabledFriendly": self.disabledFriendly,
                    "geolocation": geolocation,
                    "dataLocation": "internal",
                ]
                
                // Convert business data to JSON
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
                
                // Perform the HTTP request to register the business
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let httpResponse = response as? HTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 201:
                            // Business registered successfully
                            self.uploadBusinessImage()
                            SessionManager.shared.checkUserBusinessOwner()
                            self.showAlert(title: "Business Registered", message: "Congratulations your business has been registered with Woof")
                        case 500:
                            // Server error
                            print("Error: \(httpResponse.statusCode)")
                            self.showAlert(title: "Error", message: "Error registering business")
                        default:
                            // Unexpected error
                            print("Unexpected error occurred")
                            self.showAlert(title: "Error", message: "Error registering business")
                        }
                    }
                }.resume()
            case .failure(let error):
                // Handle forward geocoding failure
                print("Error performing forward geocoding: \(error)")
                self.showAlert(title: "Error", message: "Error registering business")
            }
        }
    }

    
    func uploadBusinessImage() {
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
        guard let updateUserURL = URL(string: "http://localhost:8080/businesses") else {
            return
        }
        
        let requestBody: [String: Any] = [
            "tablename": "businesses",
            "columns_old": ["businessID"],
            "values_old": [SessionManager.shared.ownedBusiness?.businessID],
            "columns_new": ["imgID"],
            "values_new": [imgID]
        ]
        
        var request = URLRequest(url: updateUserURL)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let requestBodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            return
        }
        
        request.httpBody = requestBodyData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating profile with image ID: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Profile updated successfully with image ID \(imgID)")
                    SessionManager.shared.checkUserBusinessOwner()
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
    
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            self.alertTitle = title
            self.alertMessage = message
            self.showAlert = true
        }
    }
}

