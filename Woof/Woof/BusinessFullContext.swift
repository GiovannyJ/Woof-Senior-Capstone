//
//  BusinessFullContext.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/8/24.
//

import SwiftUI
import Combine

// ViewModel to handle data fetching and networking for BusinessFullContextView
class BusinessFullContextViewModel: ObservableObject {
    @Published var business: Business
    @Published var imageData: Data?
    private var cancellables = Set<AnyCancellable>()
    
    init(business: Business) {
        self.business = business
        //        fetchImageInfo()
    }
    
    //    func fetchImageInfo() {
    //        guard let imgID = business.imgID?.Int64 else {
    //            print("Image ID not found")
    //            return
    //        }
    //        guard let url = URL(string: "http://localhost:8080/imageInfo?id=\(imgID)") else {
    //            print("Invalid imageInfo URL")
    //            return
    //        }
    //        print("Fetching imageInfo from: \(url)")
    //
    //        URLSession.shared.dataTaskPublisher(for: url)
    //            .map { $0.data }
    //            .decode(type: ImageInfo.self, decoder: JSONDecoder())
    //            .receive(on: DispatchQueue.main)
    //            .sink(receiveCompletion: { completion in
    //                if case .failure(let error) = completion {
    //                    print("Error fetching imageInfo:", error)
    //                }
    //            }, receiveValue: { [weak self] imageInfo in
    //                print("Received imageInfo:", imageInfo)
    //                //                self?.fetchImageData(with: imageInfo)
    //            })
    //            .store(in: &cancellables)
    //    }
    
    //    func fetchImageData(with imageInfo: ImageInfo) {
    //        guard let imgType = imageInfo.imgType, let imgName = imageInfo.imgName else {
    //            print("Invalid imageData URL")
    //            return
    //        }
    //        guard let url = URL(string: "http://localhost:8080/uploads/\(imgType)/\(imgName)") else {
    //            print("Invalid imageData URL")
    //            return
    //        }
    //        print("Fetching imageData from: \(url)")
    //
    //        URLSession.shared.dataTaskPublisher(for: url)
    //            .map { $0.data }
    //            .receive(on: DispatchQueue.main)
    //            .sink(receiveCompletion: { completion in
    //                if case .failure(let error) = completion {
    //                    print("Error fetching imageData:", error)
    //                }
    //            }, receiveValue: { [weak self] imageData in
    //                print("Received imageData:", imageData)
    //                self?.imageData = imageData
    //            })
    //            .store(in: &cancellables)
    //    }
    //}
    
    // View displaying business details and image
}
    struct BusinessFullContextView: View {
        @ObservedObject var viewModel: BusinessFullContextViewModel
        
        init(business: Business) {
            self.viewModel = BusinessFullContextViewModel(business: business)
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                // Display business details
                Text(viewModel.business.businessName)
                    .font(.headline)
                Text(viewModel.business.description)
                    .font(.subheadline)
                Text("Location: \(viewModel.business.location)")
                Text("Contact: \(viewModel.business.contact)")
                // Additional business details can be displayed here
                
                // Example: Display event if available
                if let event = viewModel.business.event {
                    Text("Event: \(event)")
                        .font(.subheadline)
                }
                
                // Example: Display rating if available
                if let rating = viewModel.business.rating {
                    Text("Rating: \(rating)")
                        .font(.subheadline)
                }
                
                // Example: Display pet-related preferences
                Text("Pet Size Preference: \(viewModel.business.petSizePref)")
                    .font(.subheadline)
                
                // Example: Display if leash policy is enforced
                Text("Leash Policy: \(viewModel.business.leashPolicy ? "Enforced" : "Not Enforced")")
                    .font(.subheadline)
                
                // Example: Display if disabled-friendly
                Text("Disabled Friendly: \(viewModel.business.disabledFriendly ? "Yes" : "No")")
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
