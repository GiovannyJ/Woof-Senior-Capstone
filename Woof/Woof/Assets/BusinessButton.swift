//
//  BusinessButton.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct BusinessButton: View {
    let business: Business

    var body: some View {
        VStack(alignment: .leading) {
            Text(business.businessName)
                .font(.headline)
            Text("Type: \(business.businessType)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Location: \(business.location)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.teal.opacity(0.1))
        .cornerRadius(8)
    }
}


struct BusinessButton_Preview: PreviewProvider {
    static let testBusiness = Business(businessID: 1, businessName: "Test Business", ownerUserID: 10, businessType: "Test type", location: "771 Rebins Bavenue", contact: "891-111-9319", description: "This is a test business for testing", event: nil, rating: nil, dataLocation: "internla", imgID: nil, petSizePref: "small", leashPolicy: true, disabledFriendly: false, reviews: nil)
    
    static var previews: some View {
        BusinessButton(business: testBusiness)
    }
}
