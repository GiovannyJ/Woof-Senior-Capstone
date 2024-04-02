//
//  ProfileView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var sessionManager = SessionManager.shared
    
    var body: some View {
        ZStack {
            // Background image
            Image("Image 4")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    profileImageSection
                    Text("User Profile")
                        .font(.title)
                        .foregroundColor(.orange)
                    
                    Group {
                        userInformationSection
                        savedBusinessesSection
                        eventsAttendingSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    .padding(.horizontal)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Profile")
        }
    }
    
    private var profileImageSection: some View {
        VStack {
            if let profileImage = sessionManager.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    .padding(.bottom, 10)
            } else {
                ProgressView()
                    .padding(.bottom, 10)
            }
        }
    }
    
    private var userInformationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("User Information")
                .font(.headline)
                .padding(.bottom, 5)
                .foregroundColor(.orange)
            
            userInfoRow(title: "Username:", value: sessionManager.currentUser?.username ?? "Guest")
            userInfoRow(title: "Email:", value: sessionManager.currentUser?.email ?? "Guest")
            
            if sessionManager.isBusinessOwner {
                if let ownedBusiness = sessionManager.ownedBusiness {
                    NavigationLink(destination: BusinessFullContext(business: ownedBusiness)) {
                        Text("Owned Business: \(ownedBusiness.businessName)")
                            .foregroundColor(.green)
                            .font(.subheadline)
                    }
                } else {
                    Text("Owned Business: None")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            }
        }
    }
    
    private var savedBusinessesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Saved Businesses")
                .font(.headline)
                .padding(.bottom, 5)
                .foregroundColor(.orange)
            
            if let businesses = sessionManager.savedBusinesses {
                if businesses.isEmpty {
                    Text("No saved businesses.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                } else {
                    ForEach(businesses, id: \.businessinfo.businessName) { savedBusiness in
                        NavigationLink(destination: BusinessFullContext(business: savedBusiness.businessinfo)) {
                            Text(savedBusiness.businessinfo.businessName)
                                .foregroundColor(.blue)
                                .font(.subheadline)
                        }
                    }
                }
            } else {
                Text("Loading...")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
        }
    }
    
    private var eventsAttendingSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Events Attending")
                .font(.headline)
                .padding(.bottom, 5)
                .foregroundColor(.orange)
            
            if let events = sessionManager.eventsAttending {
                if events.isEmpty {
                    Text("Not attending any events.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                } else {
                    ForEach(events, id: \.eventID) { event in
                        NavigationLink(destination: EventFullContextView(viewModel: EventFullContextViewModel(event: event))) {
                            Text(event.eventName)
                                .foregroundColor(.purple)
                                .font(.subheadline)
                        }
                    }
                }
            } else {
                Text("Loading...")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
        }
    }
    
    private func userInfoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .fontWeight(.bold)
            Text(value)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
