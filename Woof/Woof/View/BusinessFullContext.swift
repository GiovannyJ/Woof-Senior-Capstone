//
//  BusinessFullContext.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//  

import SwiftUI
import MapKit

    struct ReviewsView: View {
        @Binding var reviews: [Review] // Use a binding to keep the reviews array in sync with the parent view
        
        var body: some View {
            Section(header: Text("Reviews")
                .font(.title2)
                .foregroundColor(.orange)
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
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.teal.opacity(0.1), Color.teal.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading, spacing: 3) {
                    // Business information section
                    Section(header: Text("Business Information")
                        .font(.title3)
                        .foregroundColor(.teal.opacity(0.5))
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
                            .foregroundColor(.teal)
                        Text("Location:")
                            .fontWeight(.bold)
                        Text("\(viewModel.business.location)")
                            .font(.title2)
                            .foregroundColor(.teal)
                        Text("Contact:")
                            .fontWeight(.bold)
                        Text("\(viewModel.business.contact)")
                            .foregroundColor(.teal)
                            .font(.title2)
                        if let rating = viewModel.business.rating {
                            Text("Rating:")
                                .fontWeight(.bold)
                            Text("\(rating)")
                                .font(.title2)
                                .foregroundColor(.teal)
                        }
                        
                        // Example: Display pet-related preferences
                        Text("Pet Size Preference:")
                            .fontWeight(.bold)
                        Text("\(viewModel.business.petSizePref)")
                            .font(.title2)
                            .foregroundColor(.teal)
                        
                        // Example: Display if leash policy is enforced
                        Text("Leash Policy:")
                            .fontWeight(.bold)
                        Text("\(viewModel.business.leashPolicy ? "Enforced" : "Not Enforced")")
                            .font(.title2)
                            .foregroundColor(.teal)
                        
                        // Example: Display if disabled-friendly
                        Text("Disabled Friendly:")
                            .fontWeight(.bold)
                        Text(" \(viewModel.business.disabledFriendly ? "Yes" : "No")")
                            .font(.title2)
                            .foregroundColor(.teal)
                        
                        Text("Test geolocation:")
                            .fontWeight(.bold)
                        Text(" \(viewModel.business.geolocation)")
                            .font(.title2)
                            .foregroundColor(.teal)
                        
                                            // Display map with the location
                    
                    if let coordinates = ParseCoordinates(from: viewModel.business.geolocation) {
                        let annotation = CustomAnnotation(coordinate: coordinates, title: viewModel.business.businessName + "\n" + viewModel.business.location)
                        MapViewModel(centerCoordinate: coordinates, annotations: [annotation])
                            .frame(height: 200)
                            .cornerRadius(8)
                            .padding(.top, 10)
                    }
                }
                        
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
                            HStack {
                                if viewModel.isSaved {
                                    Text("Unsave Business")
                                        .foregroundColor(.red)
                                        .padding()
                                        .background(Color.orange.opacity(0.1))
                                        .cornerRadius(8)
                                        .fontWeight(.heavy)
                                } else {
                                    HStack {
                                        Image(systemName: "pawprint.fill") // Paw print icon
                                            .foregroundColor(.white.opacity(0.9))
                                            .font(.system(size: 25))
                                            .padding(.trailing, 5)
                                        
                                        Text("Save Business")
                                            .foregroundColor(.white)
                                            .padding()
                                            .font(.subheadline)
                                            .fontDesign(.rounded)
                                            .cornerRadius(8)
                                            .fontWeight(.semibold)
                                    }
                                }
                            }
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color.teal.opacity(0.4))
                            .cornerRadius(8)
                        }
                        
                        // User's review section
                        Section(header: Text("Your Review")
                            .font(.title2)
                            .foregroundColor(.orange)
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
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(8)
                            
                            
                        }
                        VStack(alignment: .leading) {
                            Button(action: {
                                viewModel.selectEventPicture()
                            }) {
                                HStack {
                                    Image(systemName: "photo")
                                        .foregroundColor(.white)
                                    
                                    // Text("Select A Picture")
                                    if let newProfileImage = viewModel.newReviewImage {
                                        Image(uiImage: newProfileImage)
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .clipShape(Circle())
                                    }
                                }
                                .padding()
                                .background(Color.teal.opacity(0.4))
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
                                .background(Color.teal.opacity(0.7))
                                .cornerRadius(8)
                                .fontWeight(.semibold)
                        }
                        // Reviews section
                        ReviewsView(reviews: $reviews)
                    }
                }
                .onReceive(viewModel.$reviews) { newReviews in
                    self.reviews = newReviews
                    //            viewModel.fetchReviews()
                }.onAppear(){
                    viewModel.fetchReviews()
                }
            }
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
        let business = Business(businessID: 1, businessName: "Paws & Claws Pet Store", ownerUserID: 1, businessType: "Pet Store", location: "123 Main St", contact: "info@pawsnclaws.com", description: "cool pet store", event: "", rating: "small", dataLocation: "internal", imgID: ImageID(Int64: 1, Valid: true), petSizePref: "small", leashPolicy: true, disabledFriendly: true, reviews: reviews, geolocation: "40.73061,-73.09164")
        
        // Creating the BusinessFullContext view with the example business
        return BusinessFullContext(business: business)
    }
}
