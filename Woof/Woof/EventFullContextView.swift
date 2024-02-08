//
//  EventFullContextView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/6/24.
//

import SwiftUI
import Combine

// ViewModel to handle data fetching and networking
class EventFullContextViewModel: ObservableObject {
    @Published var event: Event
    @Published var imageData: Data?
    private var cancellables = Set<AnyCancellable>()

    init(event: Event) {
        self.event = event
        fetchImageInfo()
    }

    func fetchImageInfo() {
        guard let url = URL(string: "http://localhost:8080/imageInfo?id=\(event.imgID.Int64)") else {
            print("Invalid imageInfo URL")
            return
        }
        print("Fetching imageInfo from: \(url)")

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ImageInfo.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching imageInfo:", error)
                }
            }, receiveValue: { [weak self] imageInfo in
                print("Received imageInfo:", imageInfo)
                self?.fetchImageData(with: imageInfo)
            })
            .store(in: &cancellables)
    }

    func fetchImageData(with imageInfo: ImageInfo) {
        guard let url = URL(string: "http://localhost:8080/uploads/\(imageInfo.imgType)/\(imageInfo.imgName)") else {
            print("Invalid imageData URL")
            return
        }
        print("Fetching imageData from: \(url)")

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching imageData:", error)
                }
            }, receiveValue: { [weak self] imageData in
                print("Received imageData:", imageData)
                self?.imageData = imageData
            })
            .store(in: &cancellables)
    }
}
// View displaying event details and image
struct EventFullContextView: View {
    @ObservedObject var viewModel: EventFullContextViewModel

    init(event: Event) {
        self.viewModel = EventFullContextViewModel(event: event)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Display event details
            Text(viewModel.event.eventName)
                .font(.headline)
            Text(viewModel.event.eventDescription)
                .font(.subheadline)
            Text("Date: \(viewModel.event.eventDate)")
            Text("Location: \(viewModel.event.location)")
            Text("Contact: \(viewModel.event.contactInfo)")
            // Additional event details can be displayed here

            // Example: Display attendance count
            Text("Attendance Count: \(viewModel.event.attendance_count)")
                .font(.subheadline)

            // Example: Display pet-related preferences
            Text("Pet Size Preference: \(viewModel.event.petSizePref)")
                .font(.subheadline)

            // Example: Display if leash policy is enforced
            Text("Leash Policy: \(viewModel.event.leashPolicy ? "Enforced" : "Not Enforced")")
                .font(.subheadline)

            // Example: Display if disabled-friendly
            Text("Disabled Friendly: \(viewModel.event.disabledFriendly ? "Yes" : "No")")
                .font(.subheadline)
            
            // Display image if available
            if let imageData = viewModel.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }
        }
        .padding()
        .background(Color.teal.opacity(0.2))
        .cornerRadius(8)
    }
}

