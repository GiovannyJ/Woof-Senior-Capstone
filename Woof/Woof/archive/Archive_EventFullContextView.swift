//
//  EventFullContextView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/6/24.
//

//import SwiftUI
//
//class EventFullContextViewModel: ObservableObject {
//    @Published var event: Event
//    @Published var imageData: Data?
//
//    init(event: Event) {
//        self.event = event
//        fetchEventImage()
//    }
//
//    func fetchEventImage() {
//        guard let imgID = self.event.imgID?.Int64 else {
//            print("Image ID not found")
//            return
//        }
//        guard let url = URL(string: "http://localhost:8080/imageInfo?id=\(imgID)") else {
//            print("Invalid URL")
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                if let error = error {
//                    print("Error fetching image data:", error.localizedDescription)
//                } else {
//                    print("No data received for event image")
//                }
//                return
//            }
//            
//            do {
//                let imageInfo = try JSONDecoder().decode([ImageInfo].self, from: data)
//                if let info = imageInfo.first {
//                    let fileURL = URL(fileURLWithPath: #file)
//                    let directoryURL = fileURL.deletingLastPathComponent()
//
//                    // Constructing the file URL
//                    let uploadsUrl = directoryURL.appendingPathComponent("uploads")
//                    let imageUrl = uploadsUrl.appendingPathComponent(info.imgType).appendingPathComponent(info.imgName)
//
//                    let imageData = try Data(contentsOf: imageUrl)
//                    DispatchQueue.main.async {
//                        self.imageData = imageData
//                    }
//                }
//            } catch {
//                print("Error decoding image info JSON:", error)
//            }
//        }.resume()
//    }
//}
// View displaying event details and image
//struct EventFullContextView: View {
//    @ObservedObject var viewModel: EventFullContextViewModel
//    
//
//    init(event: Event) {
//        self.viewModel = EventFullContextViewModel(event: event)
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            // Display event details
//            Text(viewModel.event.eventName)
//                .font(.headline)
//            Text(viewModel.event.eventDescription)
//                .font(.subheadline)
//            Text("Date: \(viewModel.event.eventDate)")
//            Text("Location: \(viewModel.event.location)")
//            Text("Contact: \(viewModel.event.contactInfo)")
//            // Additional event details can be displayed here
//
//            // Example: Display attendance count
//            Text("Attendance Count: \(viewModel.event.attendance_count)")
//                .font(.subheadline)
//
//            // Example: Display pet-related preferences
//            Text("Pet Size Preference: \(viewModel.event.petSizePref)")
//                .font(.subheadline)
//
//            // Example: Display if leash policy is enforced
//            Text("Leash Policy: \(viewModel.event.leashPolicy ? "Enforced" : "Not Enforced")")
//                .font(.subheadline)
//
//            // Example: Display if disabled-friendly
//            Text("Disabled Friendly: \(viewModel.event.disabledFriendly ? "Yes" : "No")")
//                .font(.subheadline)
//            
//            // Display image if available
//            if let imageData = viewModel.imageData,
//               let uiImage = UIImage(data: imageData) {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 200, height: 200)
//            }
//        }
//        .padding()
//        .background(Color.teal.opacity(0.2))
//        .cornerRadius(8)
//    }
//}
