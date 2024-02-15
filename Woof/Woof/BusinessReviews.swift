import SwiftUI

// ViewModel to handle data fetching and networking for BusinessReviews
class BusinessReviewsViewModel: ObservableObject {
    @Published var business: Business
    @Published var reviews: [Review] = []

    init(business: Business) {
        self.business = business
        fetchReviews()
    }

    func fetchReviews() {
        guard let url = URL(string: "http://localhost:8080/businesses/\(business.businessID)/reviews") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data received:", error?.localizedDescription ?? "Unknown error")
                return
            }

            do {
                self.reviews = try JSONDecoder().decode([Review].self, from: data)
            } catch {
                print("Error decoding reviews:", error)
            }
        }.resume()
    }
}

struct BusinessReviews: View {
    let viewModel: BusinessReviewsViewModel
    @State private var userReview: String = ""
    @State private var userRating: Int = 5 // Default rating

    init(business: Business) {
        self.viewModel = BusinessReviewsViewModel(business: business)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Business information section
                Section(header: Text("Business Information")
                            .font(.title2)
                            .foregroundColor(.teal)
                            .padding(.bottom, 5)
                ) {
                    Text("Name: \(viewModel.business.businessName)")
                    Text("Type: \(viewModel.business.businessType)")
                    Text("Location: \(viewModel.business.location)")
                    Text("Contact: \(viewModel.business.contact)")
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
                    // Submit review action (to be implemented)
                    print("Submitted review: \(userRating) stars - \(userReview)")
                }) {
                    Text("Submit Review")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal)
                        .cornerRadius(8)
                        .fontWeight(.heavy)
                }

                // Other users' reviews section
                Section(header: Text("Other Reviews")
                            .font(.title2)
                            .foregroundColor(.teal)
                            .padding(.bottom, 5)
                ) {
                    ForEach(viewModel.reviews) { review in
                        ReviewCard(review: review)
                    }
                }

                
            }
            .padding()
            .navigationTitle("Business Reviews")
        }
    }
}

// Preview for BusinessReviews
struct BusinessReviews_Previews: PreviewProvider {
    static var previews: some View {
        let business = Business(businessID: 1, businessName: "Paws & Claws Pet Store", ownerUserID: 1, businessType: "Pet Store", location: "123 Main St", contact: "info@pawsnclaws.com", description: "cool pet store", event: "", rating: "small", dataLocation: "internal", imgID: ImageID(Int64: 1, Valid: true), petSizePref: "small", leashPolicy: true, disabledFriendly: true, reviews: nil)
        return BusinessReviews(business: business)
    }
}

// Define ReviewCard struct
struct ReviewCard: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("User: \(review.userID)")
            Text("Rating: \(review.rating)")
            Text("Comment: \(review.comment)")
        }
        .padding()
        .background(Color.teal.opacity(0.2))
        .cornerRadius(8)
    }
}
