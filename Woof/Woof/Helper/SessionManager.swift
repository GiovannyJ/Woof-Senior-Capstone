//
//  SessionManager.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/4/24.
//

import Foundation
import SwiftUI
import Combine

class SessionManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn: Bool = false
    @Published var userID: Int?
    @Published var isBusinessOwner: Bool = false
    @Published var userBusinessID: Int?
    @Published var ownedBusiness: Business?
    
    static let shared = SessionManager()
    
    private init() {
        checkUserBusinessOwner()
    }
    
    func getUserID() -> Int? {
        return userID
    }
    
    public func checkUserBusinessOwner() {
        guard var urlComponents = URLComponents(string: "http://localhost:8080/businesses") else {
            print("Invalid URL")
            return
        }

        // Add query parameters
        if let userID = userID {
            urlComponents.queryItems = [URLQueryItem(name: "ownerUserID", value: String(userID))]
        } else {
            print("userID is nil")
            return
        }

        guard let url = urlComponents.url else {
            print("Invalid URL")
            return
        }

        // Perform the request
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data")
                return
            }

            do {
                // Parse JSON response into an array of Business objects
                let decodedResponse = try JSONDecoder().decode([Business].self, from: data)
                if let business = decodedResponse.first {
                    DispatchQueue.main.async {
                        // User owns a business
                        self.ownedBusiness = business
                        self.isBusinessOwner = true
                        self.userBusinessID = business.businessID
                    }
                } else {
                    // User doesn't own a business
                    DispatchQueue.main.async {
                        self.ownedBusiness = nil
                        self.isBusinessOwner = false
                        self.userBusinessID = nil
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }

}
