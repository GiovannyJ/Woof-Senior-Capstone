//
//  ProfileViewModel.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var savedBusinesses: [SavedBusinessResponse]?
    @Published var profileImage: UIImage?
    @Published var errorMessage: String?
    @ObservedObject var sessionManager = SessionManager.shared

    func fetchSavedBusinesses() {
        // Ensure user ID exists
        guard let currentUserID = sessionManager.currentUser?.userID else {
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
        guard let imgID = sessionManager.currentUser?.imgID.Int64 else {
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
                    let directoryURL = fileURL.deletingLastPathComponent()

                    // Constructing the file URL
                    let uploadsUrl = directoryURL.appendingPathComponent("uploads")
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
}
