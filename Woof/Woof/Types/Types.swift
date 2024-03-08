//
//  Types.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/6/24.
//

import Foundation

struct User: Decodable {
    let userID: Int
    let username: String
    let pwd: String
    let email: String
    let accountType: String
    let imgID: ImageID
}

struct ImageID: Decodable {
    let Int64: Int
    let Valid: Bool
}

struct Event: Decodable {
    let eventID: Int
    var attendance_count: Int
    var businessID: Int
    var contactInfo: String
    var dataLocation: String
    var disabledFriendly: Bool
    var eventDate: String
    var eventDescription: String
    var eventName: String
    var imgID: ImageID?
    var leashPolicy: Bool
    var location: String
    var petSizePref: String
    var geolocation: String
}

struct EventAttendanceResponse: Decodable{
    let userinfo: User
    let businessinfo: Business
    let eventinfo: Event
}

struct ImageInfo: Decodable{
    let imgID: Int
    let size: Int
    var imgData: String?
    let imgName: String
    let imgType: String
    let dateCreated: String
}

struct SavedBusinessResponse: Decodable {
    let userinfo: User
    let businessinfo: Business
}

struct Business: Decodable, Identifiable {
    let businessID: Int
    let businessName: String
    let ownerUserID: Int
    let businessType: String
    let location: String
    let contact: String
    let description: String
    let event: String?
    let rating: String?
    let dataLocation: String
    let imgID: ImageID?
    let petSizePref: String
    let leashPolicy: Bool
    let disabledFriendly: Bool
    let reviews: [Review]?
    var geolocation: String	

    var id: Int {
        return businessID
    }
}


struct ErrorResponse: Decodable {
    let error: String
}


struct Review: Decodable, Identifiable {
    let reviewID: Int
    let userID: Int
    let businessID: Int
    let rating: Int
    let comment: String
    let dateCreated: String
    let dataLocation: String
    let imgID: ImageID?
    var username: String? // Make username optional
    
    var id: Int {
        return reviewID
    }
}


struct BusinessReviewInfo: Decodable{
    let businessinfo: Business
    let userinfo: User
    let reviewinfo: Review
}
