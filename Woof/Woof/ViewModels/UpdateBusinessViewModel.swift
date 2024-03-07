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
    
    func updateBusiness() {
        guard let ownedBusiness = SessionManager.shared.ownedBusiness else {
            self.updateStatus = "Error: No owned business found"
            return
        }
        
        // Convert leashPolicy and disabledFriendly to 0 or 1
        let leashPolicyValue = self.leashPolicy.lowercased() == "yes" ? 1 : 0
        let disabledFriendlyValue = self.disabledFriendly.lowercased() == "yes" ? 1 : 0
        
        // Convert petSizePreference back to small, medium, or large
        let petSizePreferenceValue: String
        switch self.petSizePreference.lowercased() {
            case "small pets":
                petSizePreferenceValue = "small"
            case "medium pets":
                petSizePreferenceValue = "medium"
            case "large pets":
                petSizePreferenceValue = "large"
            default:
                petSizePreferenceValue = "small" // Default to "small" if unknown size
        }
        
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
                leashPolicyValue,
                disabledFriendlyValue,
                petSizePreferenceValue.lowercased() // Convert back to backend format
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            self.updateStatus = "Error: Failed to serialize JSON"
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
                }
                return
            }
            
            // Handle response as needed
            // You can update UI or perform additional actions here
            // For simplicity, just print the response data
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    self.updateStatus = "Business updated successfully"
                }
            } else {
                DispatchQueue.main.async {
                    self.updateStatus = "Error: Failed to update business"
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
}
