//
//  BusinessFullContextViewModel.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI
import Combine

class BusinessReviewsViewModel: ObservableObject {
    @Published var business: Business
    @Published var reviews: [Review] = []
    @Published var businessImgData: Data?
    
    @Published var newReviewImage: UIImage?
    @Published var isShowingImagePicker = false
    
    var didSelectImage: ((UIImage?) -> Void)?
    var imageUploader = ImageUploader()
    
    private let imageCache = NSCache<NSString, NSData>()
    private let reviewCache = NSCache<NSString, NSArray>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(business: Business) {
        self.business = business
//        fetchBusinessImage()
//        fetchReviews()
    }
    
    func fetchBusinessImage() {
        guard let imgID = self.business.imgID?.Int64 else {
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
                        self.businessImgData = imageData
                    }
                }
            } catch {
                print("Error decoding image info JSON:", error)
            }
        }.resume()
    }
    
    func fetchReviews() {
        // Check if the reviews are already available in the business model
        if let businessReviews = self.business.reviews, !businessReviews.isEmpty {
            self.reviews = businessReviews
            return
        }
        
        // Construct the URL for fetching reviews
        guard let url = URL(string: "http://localhost:8080/businesses/\(business.businessID)/reviews") else {
            print("Invalid URL")
            return
        }
        
        // Fetch reviews from the network
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching reviews: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let businessReviewInfos = try JSONDecoder().decode([BusinessReviewInfo].self, from: data)
                let reviewsWithUsernames = businessReviewInfos.map { businessReviewInfo -> Review in
                    var review = businessReviewInfo.reviewinfo
                    review.username = businessReviewInfo.userinfo.username
                    return review
                }
                DispatchQueue.main.async {
                    self.reviews = reviewsWithUsernames
                }
            } catch {
                print("Error decoding reviews JSON: \(error)")
            }
        }.resume()
    }


    
    func submitReview(userRating: Int, userReview: String) {
        guard let currentUserID = SessionManager.shared.currentUser?.userID else {
            print("Current user ID not found")
            return
        }
        
        guard let url = URL(string: "http://localhost:8080/reviews/user/\(currentUserID)/businesses/\(self.business.businessID)") else {
            print("Invalid URL")
            return
        }
        
        let reviewData: [String: Any] = [
            "rating": userRating,
            "comment": userReview,
            "datalocation": "internal"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: reviewData) else {
            print("Error creating HTTP body")
            return
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else {
                print("No data received:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    
                    if let responseData = data {
                       do {
                           let reviews = try JSONDecoder().decode([Review].self, from: responseData)
                           if let reviewsFirst = reviews.first {
                               // You can now access the first event object
                               print("First Review ID: \(reviewsFirst.reviewID)")
                               self.uploadReviewImage(reviewID: reviewsFirst.reviewID)
                               
                           }
                       } catch {
                           print("Error decoding event data:", error)
                           
                       }
                   } else {
                       print("No data received")
                       
                   }
                } else {
                    print("Error submitting review. Status code: \(httpResponse.statusCode)")
                    // Show an error popup
                }
            }
        }.resume()
    }
    
    func uploadReviewImage(reviewID: Int) {
        guard let image = newReviewImage else {
            return
        }
        imageUploader.uploadImage(image: image, type: "event") { result in
            switch result {
            case .success(let imgID):
                self.updateReviewWithImageID(reviewID: reviewID, imgID: imgID)
            case .failure(let error):
                print("Error uploading profile image:", error)
            }
        }
    }

    private func updateReviewWithImageID(reviewID: Int, imgID: Int) {
        // Define the URL for updating the user's profile
        guard let updateUserURL = URL(string: "http://localhost:8080/reviews") else {
            return
        }
        
        // Prepare the request body
        let requestBody: [String: Any] = [
            "tablename": "reviews",
            "columns_old": ["reviewID"],
            "values_old": [reviewID],
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
                    print("Review updated successfully with image ID \(imgID)")
                } else {
                    print("Failed to update review with image ID \(imgID): HTTP status code \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    
    func selectEventPicture() {
        isShowingImagePicker = true
    }

    func imagePickerDidSelectImage(_ image: UIImage?) {
        newReviewImage = image
        isShowingImagePicker = false
        didSelectImage?(image)
    }
    
    
    func saveBusiness(){
        guard let currentUserID = SessionManager.shared.currentUser?.userID else {
            print("Current user ID not found")
            return
        }
        
        guard let url = URL(string: "http://localhost:8080/savedbusinesses/user/\(currentUserID)") else {
            print("Invalid URL")
            return
        }
        
        let reviewData: [String: Any] = [
            "userid": currentUserID,
            "businessid": business.businessID
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: reviewData) else {
            print("Error creating HTTP body")
            return
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else {
                print("No data received:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    print("Business saved successfully")
                    // Show a success popup
                }else if httpResponse.statusCode == 400{
                    print("Business already saved")
                } else {
                    print("Error saving business. Status code: \(httpResponse.statusCode)")
                    // Show an error popup
                }
            }
        }.resume()
    }
}
