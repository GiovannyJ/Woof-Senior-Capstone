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
    @Published var leashPolicy: Bool = false
    @Published var disabledFriendly: Bool = false
    @Published var petSizePreference: String = "Small pets"
    private var geolocation: String = ""
    @Published var updateStatus: String = ""
    
    var didSelectImage: ((UIImage?) -> Void)?
    var imageUploader = ImageUploader()
    @Published var newBusinessImage: UIImage?
    @Published var isShowingImagePicker = false
    
    var showAlert = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    
    let businessTypes = ["All", "Arts & Entertainment", "Active Life", "Hotels & Travel", "Local Flavor", "Restaurants", "Shopping", "Other"]
    let petSizePreferences = ["Small pets", "Medium pets", "Large pets"]
    
    

    init() {
        if let ownedBusiness = SessionManager.shared.ownedBusiness {
            self.businessName = ownedBusiness.businessName
            self.businessType = businessTypes.contains(ownedBusiness.businessType) ? ownedBusiness.businessType : "Other"
            self.location = ownedBusiness.location
            self.contact = ownedBusiness.contact
            self.description = ownedBusiness.description
            self.leashPolicy = ownedBusiness.leashPolicy
            self.disabledFriendly = ownedBusiness.disabledFriendly
            self.petSizePreference = self.convertPetSizePref(ownedBusiness.petSizePref)
            self.geolocation = ownedBusiness.geolocation
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
                self.fetchNewBusinessImage(imgID: imgID)
                
            case .failure(let error):
                print("Error uploading profile image:", error)
                completion(.failure(error))
            }
        }
    }
    
    func updateBusiness() {
        guard let ownedBusiness = SessionManager.shared.ownedBusiness else {
            self.updateStatus = "Error: No owned business found"
            return
        }
        
        // Check if a new business image exists
        if newBusinessImage != nil {
            // Upload the new business image
            uploadBusinessImage { result in
                switch result {
                case .success(let imgID):
                    // Perform forward geocoding to get the geolocation
                    ForwardGeocoding(address: self.location) { result in
                        switch result {
                        case .success(let geolocation):
                            // Include the geolocation and imgID in the updateData JSON body
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
                                    "petSizePref",
                                    "imgID", // Include imgID in columns_new
                                    "geolocation" // Include geolocation in columns_new
                                ],
                                "values_new": [
                                    self.businessName,
                                    self.businessType,
                                    self.location,
                                    self.contact,
                                    self.description,
                                    self.leashPolicy ? 1 : 0, // Convert to 1 or 0
                                    self.disabledFriendly ? 1 : 0, // Convert to 1 or 0
                                    self.petSizePreference.lowercased().replacingOccurrences(of: " pets", with: ""), // Convert back to backend format
                                    imgID, // Include imgID in values_new
                                    geolocation // Include geolocation in values_new
                                ]
                            ]
                            
                            // Perform the PATCH request
                            self.performPatchRequest(with: requestBody)
                            
                        case .failure(let error):
                            print("Error performing forward geocoding:", error.localizedDescription)
                            self.updateStatus = "Error: \(error.localizedDescription)"
                        }
                    }
                    
                case .failure(let error):
                    print("Error uploading business image:", error)
                    self.updateStatus = "Error: \(error.localizedDescription)"
                }
            }
        } else {
            // No new business image, perform the PATCH request directly
            ForwardGeocoding(address: self.location) { result in
                switch result {
                case .success(let geolocation):
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
                            "petSizePref",
                            "geolocation"
                        ],
                        "values_new": [
                            self.businessName,
                            self.businessType,
                            self.location,
                            self.contact,
                            self.description,
                            self.leashPolicy ? 1 : 0, // Convert to 1 or 0
                            self.disabledFriendly ? 1 : 0, // Convert to 1 or 0
                            self.petSizePreference.lowercased().replacingOccurrences(of: " pets", with: ""), // Convert back to backend format
                            geolocation
                        ]
                    ]
                    
                    // Perform the PATCH request
                    self.performPatchRequest(with: requestBody)
                    
                case .failure(let error):
                    print("Error performing forward geocoding:", error.localizedDescription)
                    self.updateStatus = "Error: \(error.localizedDescription)"
                }
            }
        }
    }



    
    func performPatchRequest(with body: [String: Any]) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            updateStatus = "Error: Failed to serialize JSON"
            return
        }
        
        guard let url = URL(string: "http://localhost:8080/businesses") else {
            updateStatus = "Error: Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                DispatchQueue.main.async {
                    self.updateStatus = "Error: \(error?.localizedDescription ?? "Unknown error")"
                }
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    self.updateStatus = "Business updated successfully"
                    self.getUpdatedBusiness()
                }
            } else {
                DispatchQueue.main.async {
                    self.updateStatus = "Error: Failed to update business"
                }
            }
        }

        task.resume()
    }

    func getUpdatedBusiness() {
        guard let ownedBusiness = SessionManager.shared.ownedBusiness else {
            self.updateStatus = "Error: No owned business found"
            return
        }
        
        let urlString = "http://localhost:8080/businesses?businessID=\(ownedBusiness.businessID)"
        
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
            
            // Decode the response data into an array of Business objects
            if let businesses = try? JSONDecoder().decode([Business].self, from: data) {
                // Check if at least one business object is decoded
                guard let updatedBusiness = businesses.first else {
                    DispatchQueue.main.async {
                        self.updateStatus = "Error: No business data found"
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    // Update the owned business with the first decoded business object
                    SessionManager.shared.ownedBusiness = updatedBusiness
                    
                    // Extract the new image ID from the updated business data
                    if let imgID = updatedBusiness.imgID?.Int64 {
                        // Fetch the new business image using the new image ID
                        self.fetchNewBusinessImage(imgID: imgID)
                    }
                    
                    self.updateStatus = "Owned business updated successfully"
                    self.showAlert(title: "Business Updated", message: "Business updated successfully")
                }
            } else {
                DispatchQueue.main.async {
                    self.updateStatus = "Error: Failed to decode business data"
                    print("didnt work")
                }
            }
        }.resume()
    }



    
    func fetchNewBusinessImage(imgID: Int) {
        guard let url = URL(string: "http://localhost:8080/imageInfo?id=\(imgID)") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    print("Error fetching image data:", error.localizedDescription)
                } else {
                    print("No data received for business image")
                }
                return
            }

            do {
                let imageInfo = try JSONDecoder().decode([ImageInfo].self, from: data)
                if let info = imageInfo.first {
                    let fileURL = URL(fileURLWithPath: #file)
                    let directoryURL = fileURL.deletingLastPathComponent().deletingLastPathComponent()

                    // Constructing the file URL
                    let uploadsUrl = directoryURL.appendingPathComponent("ViewModels/uploads")
                    let imageUrl = uploadsUrl.appendingPathComponent(info.imgType).appendingPathComponent(info.imgName)

                    let imageData = try Data(contentsOf: imageUrl)
                    if let uiImage = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            // Update SessionManager's businessImage
                            SessionManager.shared.businessImage = uiImage
                        }
                    }
                }
            } catch {
                print("Error decoding image info JSON:", error)
            }
        }.resume()
    }
    
    func deleteBusiness() {
        let urlString = "http://localhost:8080/businesses"
        guard let ownedBusiness = SessionManager.shared.ownedBusiness else {
            self.updateStatus = "Error: No owned business found"
            return
        }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let requestBody: [String: Any] = [
            "tablename": "businesses",
            "column": "businessID",
            "id": ownedBusiness.businessID
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error encoding request body: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                print("Businesses deleted successfully")
                // Show alert and dismiss view
                DispatchQueue.main.async {
                    SessionManager.shared.ownedBusiness = nil
                    SessionManager.shared.isBusinessOwner = false
                    SessionManager.shared.businessImage = nil
                }
                self.showAlert(title: "Business Deleted", message: "Business Deleted Successfully")
            } else {
                print("Failed to delete business")
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
    
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            self.alertTitle = title
            self.alertMessage = message
            self.showAlert = true
        }
    }
}
