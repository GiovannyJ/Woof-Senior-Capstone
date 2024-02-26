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
}

