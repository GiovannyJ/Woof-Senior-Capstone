import SwiftUI

class BusinessReviewsViewModel: ObservableObject {
    @Published var business: Business
    @Published var reviews: [Review] = []
    @Published var businessImgData: Data?
    
    private let imageCache = NSCache<NSString, NSData>()
    private let reviewCache = NSCache<NSString, NSArray>()
    
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
        
        let cacheKey = NSString(string: "\(imgID)")
        if let cachedImageData = imageCache.object(forKey: cacheKey) {
            self.businessImgData = cachedImageData as Data
            return
        }
        
        guard let url = URL(string: "http://localhost:8080/imageInfo?id=\(imgID)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching image data:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            self.imageCache.setObject(data as NSData, forKey: cacheKey)
            DispatchQueue.main.async {
                self.businessImgData = data
            }
        }.resume()
    }
    
    func fetchReviews() {
        guard let url = URL(string: "http://localhost:8080/businesses/\(business.businessID)/reviews") else {
            print("Invalid URL")
            return
        }
        
        let cacheKey = NSString(string: "\(business.businessID)")
        if let cachedReviews = reviewCache.object(forKey: cacheKey) as? [Review] {
            self.reviews = cachedReviews
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data received:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            do {
                let businessReviewInfos = try JSONDecoder().decode([BusinessReviewInfo].self, from: data)
                let reviews = businessReviewInfos.map { $0.reviewinfo }
                self.reviews = reviews
                print(self.reviews)
                self.reviewCache.setObject(reviews as NSArray, forKey: cacheKey)
            } catch {
                print("Error decoding business review info:", error)
            }
        }.resume()
    }
    
    func submitReview(rating: Int, comment: String) {
        guard let currentUserID = SessionManager.shared.currentUser?.userID else {
            print("Current user ID not found")
            return
        }
        
        guard let url = URL(string: "http://localhost:8080/reviews/user/\(currentUserID)/businesses/\(self.business.businessID)") else {
            print("Invalid URL")
            return
        }
        
        let reviewData: [String: Any] = [
            "rating": rating,
            "comment": comment,
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

struct BusinessReviews: View {
    let viewModel: BusinessReviewsViewModel
    @State private var userReview: String = ""
    @State private var userRating: Int = 0 // Default rating

    init(business: Business) {
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
                    viewModel.submitReview(rating: userRating, comment: userReview)
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

struct BusinessReviews_Previews: PreviewProvider {
    static var previews: some View {
        let business = Business(businessID: 1, businessName: "Paws & Claws Pet Store", ownerUserID: 1, businessType: "Pet Store", location: "123 Main St", contact: "info@pawsnclaws.com", description: "cool pet store", event: "", rating: "small", dataLocation: "internal", imgID: ImageID(Int64: 1, Valid: true), petSizePref: "small", leashPolicy: true, disabledFriendly: true, reviews: nil)
        return BusinessReviews(business: business)
    }
}

struct ReviewCard: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("User: \(review.userID)").font(.headline)
            Text("Rating: \(review.rating)").font(.headline)
            Text("Comment: \(review.comment)").font(.headline)
        }
        .padding()
        .background(Color.teal.opacity(0.1))
        .cornerRadius(8)
    }
}
