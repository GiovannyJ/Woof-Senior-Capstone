import Foundation
import SwiftUI
import Combine

class RegisterAccountViewModel: ObservableObject {
    var username: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var email: String = ""
    
    var showAlert = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var newProfileImage: UIImage?
    @Published var isShowingImagePicker = false
    
    var didSelectImage: ((UIImage?) -> Void)?
    var imageUploader = ImageUploader()
    
    var cancellables = Set<AnyCancellable>()
    
    func registerUser() {
        // Check if passwords match
        guard password == confirmPassword else {
            self.showAlert(title: "Error", message: "Passwords do not match")
            return
        }
        
        // Prepare the request body
        let requestBody: [String: Any] = [
            "username": username,
            "password": password,
            "email": email,
            "accountType": "regular"
        ]
        
        // Define the URL
        guard let url = URL(string: "http://localhost:8080/users") else {
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert request body to JSON data
        guard let requestBodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            return
        }
        
        // Attach request body to the request
        request.httpBody = requestBodyData
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Handle network errors
                print(error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 201:
                    self.showAlert(title: "Success", message: "Registration successful!")
                    self.uploadProfileImage()
                case 400:
                    // Account already exists, display a message to the user
                    self.showAlert(title: "Account Already Exists", message: "An account with this email or username already exists.")
                case 500:
                    // Server error, display a generic error message to the user
                    self.showAlert(title: "Server Error", message: "An unexpected server error occurred. Please try again later.")
                default:
                    self.showAlert(title: "Error", message: "Unexpected response code: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    func uploadProfileImage() {
        guard let image = newProfileImage else {
            return
        }
        imageUploader.uploadImage(image: image, type: "profile") { result in
            switch result {
            case .success(let imgID):
                self.updateProfileWithImageID(imgID)
            case .failure(let error):
                print("Error uploading profile image:", error)
            }
        }
    }

    private func updateProfileWithImageID(_ imgID: Int) {
        // Define the URL for updating the user's profile
        guard let updateUserURL = URL(string: "http://localhost:8080/users") else {
            return
        }
        
        // Prepare the request body
        let requestBody: [String: Any] = [
            "tablename": "user",
            "columns_old": ["email"],
            "values_old": [email],
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
    
    func selectProfilePicture() {
        isShowingImagePicker = true
    }

    func imagePickerDidSelectImage(_ image: UIImage?) {
        newProfileImage = image
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
