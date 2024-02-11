import SwiftUI

// ViewModel to handle data fetching and networking for BusinessFullContextView
class BusinessFullContextViewModel: ObservableObject {
    @Published var business: Business
    @Published var imageData: Data?

    init(business: Business) {
        self.business = business
        fetchBusinessImage()
    }

    func fetchBusinessImage() {
        guard let imgID = business.imgID?.Int64 else {
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
                    print("No data received for business image")
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

// View displaying business details and image
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
