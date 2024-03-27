//
//  BusinessFullContext.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct ReviewsView: View {
    @Binding var reviews: [Review] // Use a binding to keep the reviews array in sync with the parent view
    
    var body: some View {
        Section(header: Text("Reviews")
            .font(.title2)
            .foregroundColor(.teal)
            .padding(.bottom, 5)
        ) {
            if !reviews.isEmpty {
                ForEach(reviews) { review in
                    ReviewCard(review: review, onDelete: {
                        // Remove the deleted review from the reviews array
                        reviews.removeAll(where: { $0.reviewID == review.reviewID })
                    })
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
    @ObservedObject var viewModel: BusinessReviewsViewModel
    @State private var userReview: String = ""
    @State private var userRating: Int = 1 // Default rating
    @State private var reviews: [Review] = [] // Track reviews separately
    
    public init(business: Business) {
        viewModel = BusinessReviewsViewModel(business: business)
        self.reviews = viewModel.reviews // Initialize reviews with initial data
        viewModel.fetchBusinessImage()
    }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Business information section
                Section(header: Text("Business Information")
                    .font(.title2)
                    .foregroundColor(.teal)
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)
                ) {
                    // Display business information
                    Text("\(viewModel.business.businessName)")
                        .font(.title)
                        .foregroundColor(.orange)
                    Text("Business Type:")
                        .fontWeight(.bold)
                    Text("\(viewModel.business.businessType)")
                        .font(.title2)
                    Text("Location:")
                        .fontWeight(.bold)
                    Text("\(viewModel.business.location)")
                        .font(.title2)
                    Text("Contact:")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("\(viewModel.business.contact)")
                        .font(.title2)
                    if let rating = viewModel.business.rating {
                        Text("Rating:")
                            .fontWeight(.bold)
                        Text("\(rating)")
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
                    if let businessImgData = viewModel.businessImgData,
                       let uiImage = UIImage(data: businessImgData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    }
                }
                
                if viewModel.business.businessID == SessionManager.shared.ownedBusiness?.businessID {
                    // User owns the business, don't show the save button
                    Button(action: {
                        // Handle action if needed
                    }) {
                        Text("Your Business")
                            .foregroundColor(.orange)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .fontWeight(.heavy)
                    }
                    .padding()
                } else {
                    // Business is saved, show the unsave button
                    Button(action: {
                        viewModel.toggleSaveBusiness()
                    }) {
                        if viewModel.isSaved {
                            Text("Unsave Business")
                                .foregroundColor(.red)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(8)
                                .fontWeight(.heavy)
                        } else {
                            Text("Save Business")
                                .foregroundColor(.orange.opacity(0.6))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange.opacity(0.1))
                                .font(.subheadline)
                                .fontDesign(.rounded)
                                .cornerRadius(8)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                }

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
                VStack(alignment: .leading) {
                    Button(action: {
                        viewModel.selectEventPicture()
                    }) {
                        HStack {
                            Text("Select A Picture")
                            if let newProfileImage = viewModel.newReviewImage {
                                Image(uiImage: newProfileImage)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                            }
                        }
                        .padding()
                        .background(Color.teal.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                
                    .sheet(isPresented: $viewModel.isShowingImagePicker) {
                        ImagePicker(image: $viewModel.newReviewImage, isPresented: $viewModel.isShowingImagePicker, didSelectImage: viewModel.imagePickerDidSelectImage)
                    }
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
                ReviewsView(reviews: $reviews)
            }
            .padding()
        }
        .onReceive(viewModel.$reviews) { newReviews in
            self.reviews = newReviews
//            viewModel.fetchReviews()
        }.onAppear(){
            viewModel.fetchReviews()
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

