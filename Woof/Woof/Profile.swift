//  ProfileView.swift
//  Woof
//
//  Created by Bo Nappie on 1/23/24.
//

import SwiftUI
import Foundation

struct Profile: View {
    @ObservedObject private var sessionManager = SessionManager.shared
    @State private var savedBusinesses: [SavedBusinessResponse]?
    @State private var profileImage: UIImage?
    @State private var errorMessage: String?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            if let profileImage = profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .padding()
                        } else {
                            ProgressView() // Show loading indicator while fetching image
                                .padding()
                        }
            Text("User Profile")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()
            
            // Display user information, history, saved businesses, and reviews
            ScrollView {
                Section(header: Text("User Information")) {
                    Text("Username: \(sessionManager.currentUser?.username ?? "Guest")")
                    Text("Email: \(sessionManager.currentUser?.email ?? "Guest")")
                }
                
                Section(header: Text("Saved Businesses")) {
                    if let businesses = savedBusinesses {
                        if businesses.isEmpty {
                            Text("No saved businesses.")
                        } else {
                            ForEach(businesses, id: \.businessinfo.businessID) { savedBusiness in
                                NavigationLink(destination: BusinessFullContextView(business: savedBusiness.businessinfo)) {
                                    Text(savedBusiness.businessinfo.businessName)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    } else {
                        ProgressView() // Show loading indicator while fetching data
                            .padding()
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Profile")
        .onAppear {
            fetchSavedBusinesses()
            fetchProfileImage()
        }
    }
    
    func fetchSavedBusinesses() {
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
                            if decodedData.isEmpty {
                                self.savedBusinesses = nil
                            } else {
                                self.savedBusinesses = decodedData
                            }
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                case 500:
                    // Handle 500 error
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data!)
                        errorMessage = errorResponse.error
                    } catch {
                        print("Error decoding error JSON: \(error)")
                        errorMessage = "Internal Server Error"
                    }
                default:
                    // Handle other status codes
                    errorMessage = "Unexpected error occurred"
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

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
