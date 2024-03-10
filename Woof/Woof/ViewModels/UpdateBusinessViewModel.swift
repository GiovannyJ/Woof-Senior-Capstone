//
//  UpdateBusinessViewModel.swift
//  Woof
//
//  Created by Giovanny Joseph on 3/6/24.
//

import SwiftUI
import Foundation

class UpdateBusinessViewModel: ObservableObject {
    @Published var businessName: String = ""
    @Published var businessType: String = ""
    @Published var location: String = ""
    @Published var contact: String = ""
    @Published var description: String = ""
    @Published var leashPolicy: String = ""
    @Published var disabledFriendly: String = ""
    @Published var petSizePreference: String = "Small pets"
    @Published var updateStatus: String = ""
    
    var didSelectImage: ((UIImage?) -> Void)?
    var imageUploader = ImageUploader()
    @Published var newBusinessImage: UIImage?
    @Published var isShowingImagePicker = false
    
    
    let businessTypes = ["Arts & Entertainment", "Active Life", "Hotels & Travel", "Local Flavor", "Restaurants", "Shopping", "Other"]
    let petSizePreferences = ["Small pets", "Medium pets", "Large pets"]
    
    

    init() {
        if let ownedBusiness = SessionManager.shared.ownedBusiness {
            self.businessName = ownedBusiness.businessName
            self.businessType = businessTypes.contains(ownedBusiness.businessType) ? ownedBusiness.businessType : "Other"
            self.location = ownedBusiness.location
            self.contact = ownedBusiness.contact
            self.description = ownedBusiness.description
            self.leashPolicy = ownedBusiness.leashPolicy ? "Yes" : "No"
            self.disabledFriendly = ownedBusiness.disabledFriendly ? "Yes" : "No"
            self.petSizePreference = self.convertPetSizePref(ownedBusiness.petSizePref)
        }
    }
    
    func uploadBusinessImage(completion: @escaping (Result<Int, Error>) -> Void) {
        guard let image = newBusinessImage else {
            return
        }
        
        imageUploader.uploadImage(image: image, type: "business") { result in
            switch result {
            case .success(let imgID):
                completion(.success(imgID))
            case .failure(let error):
                print("Error uploading profile image:", error)
                completion(.failure(error))
            }
        }
    }
    
    func updateBusiness(completion: @escaping (Bool) -> Void) {
        guard let ownedBusiness = SessionManager.shared.ownedBusiness else {
            self.updateStatus = "Error: No owned business found"
            return
        }
        
        // Check if a new business image exists
        if let newBusinessImage = newBusinessImage {
            // Upload the new business image
            uploadBusinessImage { result in
                switch result {
                case .success(let imgID):
                    // Include the imgID in the updateData JSON body
                    var requestBody: [String: Any] = [
                        "tablename": "businesses",
                        "columns_old": ["businessID"],
                        "values_old": [ownedBusiness.businessID],
                        "columns_new": [
                            "businessName",
                            "businessType",
                            "location",
                            "contact",
                            "description",
                            "leashPolicy",
                            "disabledFriendly",
                            "petSizePref",
                            "imgID" // Include imgID in columns_new
                        ],
                        "values_new": [
                            self.businessName,
                            self.businessType,
                            self.location,
                            self.contact,
                            self.description,
                            self.leashPolicy.lowercased() == "yes" ? 1 : 0, // Convert to 1 or 0
                            self.disabledFriendly.lowercased() == "yes" ? 1 : 0,
                            self.petSizePreference.lowercased().replacingOccurrences(of: " pets", with: ""), // Convert back to backend format
                            imgID // Include imgID in values_new
                        ]
                    ]
                    print(requestBody)
                    
                    // Perform the PATCH request
                    self.performPatchRequest(with: requestBody, completion: completion)
                    
                case .failure(let error):
                    print("Error uploading business image:", error)
                    self.updateStatus = "Error: \(error.localizedDescription)"
                    completion(false)
                }
            }
        } else {
            // No new business image, perform the PATCH request directly
            let requestBody: [String: Any] = [
                "tablename": "businesses",
                "columns_old": ["businessID"],
                "values_old": [ownedBusiness.businessID],
                "columns_new": [
                    "businessName",
                    "businessType",
                    "location",
                    "contact",
                    "description",
                    "leashPolicy",
                    "disabledFriendly",
                    "petSizePref"
                ],
                "values_new": [
                    self.businessName,
                    self.businessType,
                    self.location,
                    self.contact,
                    self.description,
                    self.leashPolicy.lowercased() == "yes" ? 1 : 0, // Convert to 1 or 0
                    self.disabledFriendly.lowercased() == "yes" ? 1 : 0,
                    self.petSizePreference.lowercased().replacingOccurrences(of: " pets", with: ""), // Convert back to backend format
                ]
            ]
            
            // Perform the PATCH request
            self.performPatchRequest(with: requestBody, completion: completion)
        }
    }

    
    func performPatchRequest(with body: [String: Any], completion: @escaping (Bool) -> Void) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            self.updateStatus = "Error: Failed to serialize JSON"
            completion(false)
            return
        }
        
        var request = URLRequest(url: URL(string: "http://localhost:8080/businesses")!)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.updateStatus = "Error: \(error?.localizedDescription ?? "Unknown error")"
                    completion(false)
                }
                return
            }
            
            // Handle response as needed
            // You can update UI or perform additional actions here
            // For simplicity, just print the response data
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    self.updateStatus = "Business updated successfully"
                    self.getUpdatedBusiness()
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    self.updateStatus = "Error: Failed to update business"
                    completion(false)
                }
            }
        }.resume()
    }

    func getUpdatedBusiness() {
        guard let ownedBusiness = SessionManager.shared.ownedBusiness else {
            self.updateStatus = "Error: No owned business found"
            return
        }
        
        let urlString = "http://localhost:8080/businesses?id=\(ownedBusiness.businessID)"
        
        guard let url = URL(string: urlString) else {
            self.updateStatus = "Error: Invalid URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.updateStatus = "Error: \(error?.localizedDescription ?? "Unknown error")"
                }
                return
            }
            
            // Decode the response data into Business object
            if let updatedBusiness = try? JSONDecoder().decode(Business.self, from: data) {
                DispatchQueue.main.async {
                    // Update the owned business with the updated business data
                    SessionManager.shared.ownedBusiness = updatedBusiness
                    SessionManager.shared.fetchBusinessImage()
                    self.updateStatus = "Owned business updated successfully"
                }
            } else {
                DispatchQueue.main.async {
                    self.updateStatus = "Error: Failed to decode business data"
                }
            }
        }.resume()
    }
    
    private func convertPetSizePref(_ size: String) -> String {
        switch size {
        case "small":
            return "Small pets"
        case "medium":
            return "Medium pets"
        case "large":
            return "Large pets"
        default:
            return "Small pets" // Default to "Small pets" if unknown size
        }
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
