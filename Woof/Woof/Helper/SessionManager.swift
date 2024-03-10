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
    @Published var eventsAttending: [Event]?
    @Published var savedBusinesses: [SavedBusinessResponse]?
    @Published var errorMessage: String?
    @Published var profileImage: UIImage?
    @Published var businessImage: UIImage?
    
    @Published var locationManager: LocationManager?
    @Published var isLocating: Bool = false
    
    static let shared = SessionManager()
    
//    private init() {
//        checkUserBusinessOwner()
//        fetchEventsAttending()
//    }
    
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
                        self.fetchBusinessImage()
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
                DispatchQueue.main.async {
                    self.ownedBusiness = nil
                    self.isBusinessOwner = false
                    self.userBusinessID = nil
                }
            }
        }.resume()
    }
    
    public func fetchEventsAttending() {
        guard let currentUserID = self.currentUser?.userID else {
            print("User ID not found")
            return
        }
        guard let url = URL(string: "http://localhost:8080/users/\(currentUserID)/attendance") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    print("Error fetching events data:", error.localizedDescription)
                } else {
                    print("No data received for events")
                }
                return
            }
            
            do {
                let eventAttendanceResponses = try JSONDecoder().decode([EventAttendanceResponse].self, from: data)
                let events = eventAttendanceResponses.map { $0.eventinfo }
                DispatchQueue.main.async {
                    self.eventsAttending = events
                }
            } catch {
                print("Error decoding events JSON:", error)
                DispatchQueue.main.async {
                    self.eventsAttending = nil
                }
            }
        }.resume()
    }
    
    func fetchSavedBusinesses() {
        // Ensure user ID exists
        guard let currentUserID = currentUser?.userID else {
            print("User ID not found")
            return
        }
        guard let url = URL(string: "http://localhost:8080/users/\(currentUserID)/savedbusinesses") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    // Successful response
                    do {
                        let decodedData = try JSONDecoder().decode([SavedBusinessResponse].self, from: data!)
                        DispatchQueue.main.async {
                            self.savedBusinesses = decodedData.isEmpty ? nil : decodedData
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                        DispatchQueue.main.async {
                            self.savedBusinesses = nil
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
                        print("Error decoding error JSON: \(error)")
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
    
    func fetchProfileImage() {
        guard let imgID = currentUser?.imgID.Int64 else {
            print("Image ID not found")
            return
        }
        guard let url = URL(string: "http://localhost:8080/imageInfo?id=\(imgID)") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    print("Error fetching image data:", error.localizedDescription)
                } else {
                    print("No data received for profile image")
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
//                    let uploadsUrl = URL(fileURLWithPath: "/Woof-Senior-Capstone/Woof/Woof/ViewModels/uploads")
                    let imageUrl = uploadsUrl.appendingPathComponent(info.imgType).appendingPathComponent(info.imgName)

                    let imageData = try Data(contentsOf: imageUrl)
                    if let uiImage = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.profileImage = uiImage
                        }
                    }
                }
            } catch {
                print("Error decoding image info JSON:", error)
            }
        }.resume()
    }
    
    func fetchBusinessImage() {
        guard let imgID = ownedBusiness?.imgID?.Int64 else {
            print("Image ID not found")
            return
        }
        guard let url = URL(string: "http://localhost:8080/imageInfo?id=\(imgID)") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    print("Error fetching image data:", error.localizedDescription)
                } else {
                    print("No data received for profile image")
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
//                    let uploadsUrl = URL(fileURLWithPath: "/Woof-Senior-Capstone/Woof/Woof/ViewModels/uploads")
                    let imageUrl = uploadsUrl.appendingPathComponent(info.imgType).appendingPathComponent(info.imgName)

                    let imageData = try Data(contentsOf: imageUrl)
                    if let uiImage = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.businessImage = uiImage
                        }
                    }
                }
            } catch {
                print("Error decoding image info JSON:", error)
            }
        }.resume()
    }
    
}
