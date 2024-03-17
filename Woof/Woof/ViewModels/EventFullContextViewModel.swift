//
//  EventFullContextViewModel.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

class EventFullContextViewModel: ObservableObject {
    @Published var event: Event
    @Published var imageData: Data?
    @Published var isAttending: Bool = false
    
    init(event: Event) {
        self.event = event
        self.fetchEventImage()
    }
    
    func toggleAttendance() {
        isAttending.toggle() // Toggle the isAttending flag
        if isAttending {
            attendEvent()
        } else {
            unattendEvent()
        }
        self.fetchEventImage()
    }
    
    private func attendEvent() {
        let url = URL(string: "http://localhost:8080/events/attendance")!
        let userID = SessionManager.shared.currentUser?.userID
        let body: [String: Any] = [
            "userID": userID ?? 0,
            "eventID": event.eventID,
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Error encoding data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error attending event: \(error)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 201:
                        // Successful response
                        print("Event Attending!")
                        DispatchQueue.main.async {
                            SessionManager.shared.fetchEventsAttending()
                            self.fetchEventImage()
                        }
                    case 400:
                        // Error response
                        print("User is already attending event")
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
    
    private func unattendEvent() {
        let urlString = "http://localhost:8080/attendance"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        var requestBody: [String: Int] = [:]
        if let userID = SessionManager.shared.currentUser?.userID {
            requestBody = [
                "userID": userID,
                "eventID": event.eventID,
            ]
        } else {
            print("no userID")
            // Handle the case where userID is not available
            return
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error encoding request body: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error unattending event: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                    // Successful response
                    print("Event unattended successfully")
                    DispatchQueue.main.async {
                        SessionManager.shared.fetchEventsAttending()
                        self.fetchEventImage()
                    }
                default:
                    // Handle other status codes
                    print("Failed to unattend event")
                }
            }
        }.resume()
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
}

