//
//  BusinessFullContext.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct BusinessFullContext: View {
    let viewModel: BusinessReviewsViewModel
    @State private var userReview: String = ""
    @State private var userRating: Int = 0 // Default rating

    public init(business: Business) {
        self.viewModel = BusinessReviewsViewModel(business: business)
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
                    if let businessImgData = viewModel.businessImgData,
                       let uiImage = UIImage(data: businessImgData){
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    }
                }
                // Button to Save Business NONFUNCTIONAL ATM
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
                // User's review section
                Section(header: Text("Your Review")
                            .font(.title2)
                            .foregroundColor(.teal)
                            .padding(.bottom, 5)
                ) {
                    // Rating picker
                    Picker("Rating", selection: $userRating) {
                        ForEach(1..<6) { rating in
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
                }) {
                    Text("Submit Review")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal)
                        .cornerRadius(8)
                        .fontWeight(.heavy)
                }

                Section(header: Text("Other Reviews")
                            .font(.title2)
                            .foregroundColor(.teal)
                            .padding(.bottom, 5)
                ) {
                    // Check if there are reviews
                    if !viewModel.reviews.isEmpty {
                        ForEach(viewModel.reviews) { review in
                            ReviewCard(review: review)
                        }
                    } else {
                        Text("No one is barking up this tree yet")
                            .foregroundColor(.gray)
                            .padding(.vertical)
                    }
                }

                
            }
            .padding()
            .onAppear(){
                viewModel.fetchReviews()
                viewModel.fetchBusinessImage()
            }
        }
    }
}

struct BusinessFullContext_Previews: PreviewProvider {
    static var previews: some View {
        let business = Business(businessID: 1, businessName: "Paws & Claws Pet Store", ownerUserID: 1, businessType: "Pet Store", location: "123 Main St", contact: "info@pawsnclaws.com", description: "cool pet store", event: "", rating: "small", dataLocation: "internal", imgID: ImageID(Int64: 1, Valid: true), petSizePref: "small", leashPolicy: true, disabledFriendly: true, reviews: nil, geolocation: "here")
        return BusinessFullContext(business: business)
    }
}
