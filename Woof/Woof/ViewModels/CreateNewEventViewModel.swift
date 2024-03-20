//
//  CreateNewEventViewModel.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import Foundation
import SwiftUI
import Combine

class CreateEventViewModel: ObservableObject {
    @Published  var eventName: String = ""
    @Published  var eventDescription: String = ""
    @Published  var eventDate: Date = Date()
    @Published  var location: String = ""
    @Published  var contactInfo: String = ""
    @Published  var petSizePref: String = "small"
    @Published  var leashPolicy: Bool = false
    @Published  var disabledFriendly: Bool = false
    @Published var newProfileImage: UIImage?
    @Published var isShowingImagePicker = false
    
    var showAlert = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    
    var didSelectImage: ((UIImage?) -> Void)?
    var imageUploader = ImageUploader()
    
    
    func submitEvent(completion: @escaping (Bool) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Specify the desired format
        let formattedDate = dateFormatter.string(from: eventDate)
        
        let businessID = SessionManager.shared.userBusinessID
        let url = URL(string: "http://localhost:8080/events/businesses/\(businessID ?? 0)")!
        let body: [String: Any] = [
            "eventName": eventName,
            "eventDescription": eventDescription,
            "eventDate": formattedDate,
            "location": location,
            "contactInfo": contactInfo,
            "petSizePref": petSizePref,
            "leashPolicy": leashPolicy,
            "disabledFriendly": disabledFriendly,
            "datalocation": "internal"
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Error encoding data")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 201:
                    // Successful response
                    print("Event Created!")
                    if let responseData = data {
                       do {
                           let events = try JSONDecoder().decode([Event].self, from: responseData)
                           if let firstEvent = events.first {
                               // You can now access the first event object
                               print("First Event ID: \(firstEvent.eventID)")
                               self.uploadEventImage(eventID: firstEvent.eventID)
                               completion(true)
                               DispatchQueue.main.async {
                                   self.showAlert(title: "Event Created", message: "Event Created Successfully")
                                   self.eventName = ""
                                   self.eventDescription  = ""
                                   self.eventDate = Date()
                                   self.location = ""
                                   self.contactInfo  = ""
                                   self.petSizePref  = "small"
                                   self.leashPolicy  = false
                                   self.disabledFriendly  = false
                                   self.newProfileImage = nil
                               }
                           }
                       } catch {
                           print("Error decoding event data:", error)
                           self.showAlert(title: "Event Failed to create", message: "Event Creation Failed")
                           completion(false)
                       }
                   } else {
                       print("No data received")
                       self.showAlert(title: "Event Failed to create", message: "Event Creation Failed")
                       completion(false)
                   }
               case 500:
                   // Handle 500 error
                   print("Error: \(httpResponse.statusCode)")
                    self.showAlert(title: "Event Failed to create", message: "Event Creation Failed")
                   completion(false)
               default:
                   // Handle other status codes
                   print("Unexpected error occurred")
                    self.showAlert(title: "Event Failed to create", message: "Event Creation Failed")
                   completion(false)
               }
           }
       }.resume()
    }
    
    func uploadEventImage(eventID: Int) {
        guard let image = newProfileImage else {
            return
        }
        imageUploader.uploadImage(image: image, type: "event") { result in
            switch result {
            case .success(let imgID):
                self.updateEventWithImageID(eventID: eventID, imgID: imgID)
            case .failure(let error):
                print("Error uploading profile image:", error)
            }
        }
    }

    private func updateEventWithImageID(eventID: Int, imgID: Int) {
        // Define the URL for updating the user's profile
        guard let updateUserURL = URL(string: "http://localhost:8080/events") else {
            return
        }
        
        // Prepare the request body
        let requestBody: [String: Any] = [
            "tablename": "events",
            "columns_old": ["eventID"],
            "values_old": [eventID],
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
    
    
    func selectEventPicture() {
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
