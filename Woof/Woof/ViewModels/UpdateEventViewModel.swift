//
//  UpdateEventViewModel.swift
//  Woof
//
//  Created by Giovanny Joseph on 3/6/24.
//

import SwiftUI
import Foundation

class UpdateEventViewModel: ObservableObject {
    @Published var event: Event
    @Published var imageData: Data?
    
    var didSelectImage: ((UIImage?) -> Void)?
    var imageUploader = ImageUploader()
    @Published var newEventImage: UIImage?
    @Published var isShowingImagePicker = false
    
    var showAlert = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    init(event: Event) {
        self.event = event
    }
    
    func fetchEventImage() {
        guard let imgID = self.event.imgID?.Int64 else {
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
                    print("No data received for event image")
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
                    DispatchQueue.main.async {
                        self.imageData = imageData
                    }
                }
            } catch {
                print("Error decoding image info JSON:", error)
            }
        }.resume()
    }
    
    func uploadEventImage(completion: @escaping (Result<Int, Error>) -> Void) {
        guard let image = newEventImage else {
            return
        }
        
        imageUploader.uploadImage(image: image, type: "event") { result in
            switch result {
            case .success(let imgID):
                completion(.success(imgID))
            case .failure(let error):
                print("Error uploading profile image:", error)
                completion(.failure(error))
            }
        }
    }
    
    func updateEvent() {
        // Convert leashPolicy and disabledFriendly to 1 or 0
        let leashPolicyValue = event.leashPolicy ? 1 : 0
        let disabledFriendlyValue = event.disabledFriendly ? 1 : 0
        
        // Check if a new event image exists
        if newEventImage != nil {
            // Upload the new event image
            uploadEventImage { result in
                switch result {
                case .success(let imgID):
                    // Include the imgID in the updateData JSON body
                    let requestBody: [String: Any] = [
                        "tablename": "events",
                        "columns_old": ["eventID"],
                        "values_old": [self.event.eventID],
                        "columns_new": ["eventName", "eventDescription", "eventDate", "location", "contactInfo", "leashPolicy", "disabledFriendly", "petSizePref", "imgID"],
                        // Updated the values for leashPolicy, disabledFriendly, and imgID
                        "values_new": [self.event.eventName, self.event.eventDescription, self.event.eventDate, self.event.location, self.event.contactInfo, leashPolicyValue, disabledFriendlyValue, self.event.petSizePref, imgID]
                    ]
                    
                    // Perform the PATCH request
                    self.performPatchRequest(with: requestBody)
                    
                case .failure(let error):
                    print("Error uploading event image:", error)
                }
            }
        } else {
            // No new event image, perform the PATCH request directly
            let requestBody: [String: Any] = [
                "tablename": "events",
                "columns_old": ["eventID"],
                "values_old": [event.eventID],
                "columns_new": ["eventName", "eventDescription", "eventDate", "location", "contactInfo", "leashPolicy", "disabledFriendly", "petSizePref"],
                // Updated the values for leashPolicy and disabledFriendly
                "values_new": [event.eventName, event.eventDescription, event.eventDate, event.location, event.contactInfo, leashPolicyValue, disabledFriendlyValue, event.petSizePref]
            ]
            
            // Perform the PATCH request
            self.performPatchRequest(with: requestBody)
        }
    }
    
    func performPatchRequest(with body: [String: Any]) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Error: Failed to serialize JSON")
            return
        }
        
        var request = URLRequest(url: URL(string: "http://localhost:8080/events")!)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Handle response as needed
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                // Event updated successfully, fetch the updated event
                self.getUpdatedEvent(eventID: self.event.eventID)
                self.showAlert(title: "Event updated", message: "Event updated successfully")
            } else {
                print("Error: Failed to update event")
            }
        }.resume()
    }

    
    func getUpdatedEvent(eventID: Int) {
        let urlString = "http://localhost:8080/events?eventID=\(eventID)"
        
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            print(data)
            // Decode the response data into Event object
            if let updatedEvent = try? JSONDecoder().decode(Event.self, from: data) {
                DispatchQueue.main.async {
                    // Update the event with the updated event data
                    self.event = updatedEvent
                }
            } else {
                print("Error: Failed to decode event data")
            }
        }.resume()
    }
    
    func deleteEvent() {
        let urlString = "http://localhost:8080/events"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let requestBody: [String: Any] = [
            "tablename": "events",
            "column": "eventID",
            "id": event.eventID
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
                print("Event deleted successfully")
                // Show alert and dismiss view
                self.showAlert(title: "Event Deleted", message: "Event deleted successfully")
            } else {
                print("Failed to delete event")
            }
        }.resume()
    }
    
    
    
    func selectEventPicture() {
        isShowingImagePicker = true
    }

    func imagePickerDidSelectImage(_ image: UIImage?) {
        newEventImage = image
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
