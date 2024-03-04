//
//  ReviewCard.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct ReviewCard: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let username = review.username {
                Text("User: \(username)").font(.headline)
            } else {
                Text("User: Guest").font(.headline)
            }
            Text("Rating: \(review.rating)").font(.headline)
            Text("Comment: \(review.comment)").font(.headline)
        }
        .padding()
        .background(Color.teal.opacity(0.1))
        .cornerRadius(8)
    }
}


struct ReviewCard_Previews: PreviewProvider {
    static let testReview = Review(reviewID: 1, userID: 1,businessID: 1, rating: 5, comment: "test comment", dateCreated: "1/1/2024", dataLocation: "internal", imgID: nil)
    
    static var previews: some View {
        ReviewCard(review: testReview)
    }
}
