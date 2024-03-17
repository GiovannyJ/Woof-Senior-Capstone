//
//  ReviewCard.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct ReviewCard: View {
    let review: Review
    @State private var reviewImageData: Data?
    var onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let username = review.username {
                Text("User: \(username)").font(.headline)
            } else {
                Text("User: Guest").font(.headline)
            }
            Text("Rating: \(review.rating)").font(.headline)
            Text("Comment: \(review.comment)").font(.headline)
            if let reviewImage = reviewImageData,
               let uiImage = UIImage(data: reviewImage) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }
            Button(action: deleteReview) {
                Text("Delete Review")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.teal.opacity(0.1))
        .cornerRadius(8)
        .onAppear {
            fetchBusinessImage()
        }
    }
    
    func fetchBusinessImage() {
        guard let imgID = self.review.imgID?.Int64 else {
            print("Image ID not found")
            return
        }
        if imgID == 0{
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
                    let directoryURL = fileURL.deletingLastPathComponent().deletingLastPathComponent()

                    // Constructing the file URL
                    let uploadsUrl = directoryURL.appendingPathComponent("ViewModels").appendingPathComponent("uploads")
                    let imageUrl = uploadsUrl.appendingPathComponent(info.imgType).appendingPathComponent(info.imgName)

                    let imageData = try Data(contentsOf: imageUrl)
                    DispatchQueue.main.async {
                        self.reviewImageData = imageData
                    }
                }
            } catch {
                print("Error decoding image info JSON:", error)
            }
        }.resume()
    }
    
    private func deleteReview() {
        let urlString = "http://localhost:8080/reviews"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let requestBody: [String: Any] = [
            "tablename": "reviews",
            "column": "reviewID",
            "id": review.reviewID
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
                print(" deleted successfully")
            } else {
                print("Failed to delete")
            }
            onDelete()
        }.resume()
    }
}

struct ReviewCard_Previews: PreviewProvider {
    static let img = ImageID(Int64: 30, Valid: true)
    
    static let testReview = Review(reviewID: 1, userID: 1,businessID: 1, rating: 5, comment: "test comment", dateCreated: "1/1/2024", dataLocation: "internal", imgID: img)
    
    static var previews: some View {
        ReviewCard(review: testReview, onDelete: {})
    }
}
