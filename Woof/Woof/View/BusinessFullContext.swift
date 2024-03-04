//
//  BusinessFullContext.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct ReviewsView: View {
    let reviews: [Review]

    var body: some View {
        Section(header: Text("Reviews")
            .font(.title2)
            .foregroundColor(.teal)
            .padding(.bottom, 5)
        ) {
            if !reviews.isEmpty {
                ForEach(reviews) { review in
                    ReviewCard(review: review)
                }
            } else {
                Text("No reviews yet")
                    .foregroundColor(.gray)
                    .padding(.vertical)
            }
        }
    }
}

struct BusinessFullContext: View {
    let viewModel: BusinessReviewsViewModel
    @State private var userReview: String = ""
    @State private var userRating: Int = 0 // Default rating
    @State private var reviews: [Review] = [] // Track reviews separately
    
    public init(business: Business) {
        self.viewModel = BusinessReviewsViewModel(business: business)
        self.reviews = viewModel.reviews // Initialize reviews with initial data
        print(viewModel.reviews)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Business information section
                Section(header: Text("Business Information")
                    .font(.title)
                    .foregroundColor(.teal)
                    .fontWeight(.heavy)
                    .padding(.bottom, 5)
                ) {
                    // Display business information
                    Text("\(viewModel.business.businessName)")
                        .font(.title)
                        .foregroundColor(.orange)
                    Text("Type: \(viewModel.business.businessType)")
                        .font(.title2)
                    Text("Location: \(viewModel.business.location)")
                        .font(.title2)
                    Text("Contact: \(viewModel.business.contact)")
                        .font(.title2)
                    if let rating = viewModel.business.rating {
                        Text("Rating: \(rating)")
                            .font(.title2)
                    }
                    
                    // Example: Display pet-related preferences
                    Text("Pet Size Preference: \(viewModel.business.petSizePref)")
                        .font(.title2)
                    
                    // Example: Display if leash policy is enforced
                    Text("Leash Policy: \(viewModel.business.leashPolicy ? "Enforced" : "Not Enforced")")
                        .font(.title2)
                    
                    // Example: Display if disabled-friendly
                    Text("Disabled Friendly: \(viewModel.business.disabledFriendly ? "Yes" : "No")")
                        .font(.title2)
                    
                    Text("Test geolocation: \(viewModel.business.geolocation)")
                        .font(.title2)
                    
                    // Display business image
                    //                    if let businessImgData = viewModel.businessImgData,
                    //                       let uiImage = UIImage(data: businessImgData) {
                    //                        Image(uiImage: uiImage)
                    //                            .resizable()
                    //                            .aspectRatio(contentMode: .fit)
                    //                            .frame(width: 200, height: 200)
                    //                    }
                }
                
                Button(action: {
                    viewModel.saveBusiness()
                }) {
                    Text("Save Business")
                        .foregroundColor(.teal)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal.opacity(0.1))
                        .cornerRadius(8)
                        .fontWeight(.heavy)
                }
                .padding()

                // User's review section
                Section(header: Text("Your Review")
                    .font(.title2)
                    .foregroundColor(.teal)
                    .padding(.bottom, 5)
                )
                {
                    // Rating picker
                    Picker("Rating", selection: $userRating) {
                        ForEach(1...5, id: \.self) { rating in
                            Text("\(rating)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    // Review text field
                    TextField("Leave a review", text: $userReview)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                // Button to submit review
                Button(action: {
                    // Submit review action
                    viewModel.submitReview(userRating: userRating, userReview: userReview)
                    // Clear the review text field and reset rating after submitting
                    userReview = ""
                    userRating = 0
                }) {
                    Text("Submit Review")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal)
                        .cornerRadius(8)
                        .fontWeight(.heavy)
                }
                // Reviews section
                ReviewsView(reviews: reviews)
            }
            .padding()
        }
        .onReceive(viewModel.$reviews) { newReviews in
            // Update the reviews when the view model's reviews change
            self.reviews = newReviews
        }
    }
}


struct BusinessFullContext_Previews: PreviewProvider {
    static var previews: some View {
        // Creating example reviews
        let reviews: [Review] = [
            Review(reviewID: 1, userID: 1, businessID: 1, rating: 4, comment: "Great service!", dateCreated: "2024-02-24", dataLocation: "internal", imgID: nil, username: ""),
            Review(reviewID: 2, userID: 2, businessID: 1, rating: 5, comment: "Amazing experience!", dateCreated: "2024-02-23", dataLocation: "internal", imgID: nil, username: ""),
            Review(reviewID: 3, userID: 3, businessID: 1, rating: 3, comment: "Could be better", dateCreated: "2024-02-22", dataLocation: "internal", imgID: nil, username: "")
        ]
        
        // Creating a Business instance for the BusinessFullContext
        let business = Business(businessID: 1, businessName: "Paws & Claws Pet Store", ownerUserID: 1, businessType: "Pet Store", location: "123 Main St", contact: "info@pawsnclaws.com", description: "cool pet store", event: "", rating: "small", dataLocation: "internal", imgID: ImageID(Int64: 1, Valid: true), petSizePref: "small", leashPolicy: true, disabledFriendly: true, reviews: reviews, geolocation: "here")
        
        // Creating the BusinessFullContext view with the example business
        return BusinessFullContext(business: business)
    }
}

