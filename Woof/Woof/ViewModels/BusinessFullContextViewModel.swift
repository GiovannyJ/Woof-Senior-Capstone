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
    
    private let imageCache = NSCache<NSString, NSData>()
    private let reviewCache = NSCache<NSString, NSArray>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(business: Business) {
        self.business = business
//        fetchBusinessImage()
        fetchReviews()
    }
    
    func fetchBusinessImage() {
        guard let imgID = self.business.imgID?.Int64 else {
            print("Image ID not found")
            return
        }
        
        let cacheKey = NSString(string: "\(imgID)")
        if let cachedImageData = imageCache.object(forKey: cacheKey) {
            self.businessImgData = cachedImageData as Data
            return
        }
        
        guard let url = URL(string: "http://localhost:8080/imageInfo?id=\(imgID)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main) // Ensure updates are performed on the main thread
            .sink { [weak self] data in
                guard let data = data else { return }
                self?.imageCache.setObject(data as NSData, forKey: cacheKey)
                self?.businessImgData = data
            }
            .store(in: &cancellables)
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
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [BusinessReviewInfo].self, decoder: JSONDecoder())
            .map { $0.map { $0.reviewinfo } }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main) // Ensure updates are performed on the main thread
            .sink { [weak self] reviews in
                self?.reviews = reviews
//                print(self?.reviews)
            }
            .store(in: &cancellables)
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
                    print("Review submitted successfully")
                    // Show a success popup
                } else {
                    print("Error submitting review. Status code: \(httpResponse.statusCode)")
                    // Show an error popup
                }
            }
        }.resume()
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
