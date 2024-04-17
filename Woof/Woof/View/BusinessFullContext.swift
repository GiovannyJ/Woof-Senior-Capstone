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
                GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .leading) {
                            // Business information section
                            VStack(alignment: .leading, spacing: 10) {
                                // Display business information
                                Text("\(viewModel.business.businessName)")
                                    .font(.title)
                                    .foregroundColor(.orange)
                                Text("\(viewModel.business.description)")
                                    .bold()
                                Text("Business Type: \(viewModel.business.businessType)")
                                    .foregroundColor(.teal)
                                Text("Location: \(viewModel.business.location)")
                                    .foregroundColor(.teal)
                                Text("Contact: \(viewModel.business.contact)")
                                    .foregroundColor(.teal)
                                if let rating = viewModel.business.rating {
                                    Text("Rating: \(rating) \(Image(systemName: "pawprint.fill"))'s")
                                        .foregroundColor(.teal)
                                }else{
                                    Text("Rating: No Ratings Yet")
                                        .foregroundColor(.teal)
                                }
                                Text("Pet Size Preference: \(viewModel.business.petSizePref)")
                                    .foregroundColor(.teal)
                                Text("Leash Policy: \(viewModel.business.leashPolicy ? "Enforced" : "Not Enforced")")
                                    .foregroundColor(.teal)
                                Text("Disabled Friendly: \(viewModel.business.disabledFriendly ? "Yes" : "No")")
                                    .foregroundColor(.teal)
                                
                                // Display map with the location
                                Text("Find Us Here:")
                                if let coordinates = ParseCoordinates(from: viewModel.business.geolocation) {
                                    let annotation = CustomAnnotation(coordinate: coordinates, title: viewModel.business.businessName + "\n" + viewModel.business.location, type: "business")
                                    MapViewModel(centerCoordinate: coordinates, annotations: [annotation])
                                        .frame(height: 200)
                                        .cornerRadius(8)
                                        .padding(.top, 10)
                                }
                                
                                // Display business image
                                if let businessImgData = viewModel.businessImgData,
                                   let uiImage = UIImage(data: businessImgData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 200, height: 200)
                                }
                                
                                // Button to save/unsave business
                                if viewModel.business.businessID == SessionManager.shared.ownedBusiness?.businessID {
                                                        // User owns the business, don't show the save button
                                                        Button(action: {
                                                            // Handle action if needed
                                                        }) {
                                                            HStack {
                                                                Image(systemName: "pawprint.fill")
                                                                    .foregroundColor(.white.opacity(0.9))
                                                                    .font(.system(size: 25))
                                                                    .padding(.trailing, 5)
                                                                Text("Your Business")
                                                                    .foregroundColor(.orange)
                                                                    .padding()
//                                                                    .frame(maxWidth: .infinity)
                                                                    
                                                                    .cornerRadius(8)
                                                                    .fontWeight(.heavy)
                                                            }
                                                        }
                                                        .padding()
                                                        .padding(.horizontal, 30)
                                                        .background(Color.teal.opacity(0.4))
                                                        .cornerRadius(8)
                                                    } else {
                             
                                    Button(action: {
                                        viewModel.toggleSaveBusiness()
                                    }) {
                                        HStack {
                                            if viewModel.isSaved {
                                                HStack {
                                                    Image(systemName: "pawprint.fill")
                                                        .foregroundColor(.white.opacity(0.9))
                                                        .font(.system(size: 25))
                                                        .padding(.trailing, 5)
                                                    Text("Unsave Business")
                                                        .foregroundColor(.red)
                                                        .padding()
                                                        
                                                        .cornerRadius(8)
                                                        .fontWeight(.heavy)
                                                }
                                            } else {
                                                HStack {
                                                    Image(systemName: "pawprint.fill")
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
                                        .padding()
                                        .padding(.horizontal, 30)
                                        .background(Color.teal.opacity(0.4))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                            .padding(.horizontal, 20) // Add horizontal padding
                            
                            
                            
                            // User's review section
                            VStack(){
                                Section(header: Text("Your Review")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                    .padding(.bottom, 5)
                                    
                                    .padding(.top, 10)
                                    .underline()
                                )
                                {
                                    // Rating picker
                                    Picker("Rating", selection: $userRating) {
                                        ForEach(1...5, id: \.self) { rating in
                                            Text("\(rating)")
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .padding(.bottom, 10)
                                    
                                    // Review text field
                                    TextField("Leave a review", text: $userReview)
                                        .padding()
                                        .background(Color.white.opacity(0.5))
                                        .cornerRadius(8)
                                        .padding(.bottom, 30)
                                }
                                Spacer()
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
                            }
                            .padding(.horizontal)
                        }
                    
                    // Review section
                    VStack(){
                        Section(header: Text("Reviews")
                            .font(.title2)
                            .foregroundColor(.orange)
                            .padding(.bottom, 5)
                            .padding(.horizontal, 100) // Add horizontal padding
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
                .onReceive(viewModel.$reviews) { newReviews in
                    self.reviews = newReviews
                }
                .onAppear(){
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
