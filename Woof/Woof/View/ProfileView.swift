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
        NavigationStack{
            ZStack {
                
                // Background image
//                Image("Image 4")
//                    .resizable()
//                    .scaledToFill()
//                    .edgesIgnoringSafeArea(.all)
//                    .opacity(0.5) // Adj
                
                ScrollView {
                    VStack {
                        Spacer() // Pushes the profile button to the top
                        HStack {
                            Spacer() // Pushes the profile button to the right
                            NavigationLink(destination: UpdateAccountView()) {
                                Image(systemName: "person.crop.circle.fill.badge.plus")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.orange.opacity(0.8))
                                    .clipShape(Circle())
                                    .padding([.top, .trailing], 16)
                            }
                        }
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
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                            .padding(.horizontal)
                        }
                        .padding(.top, 20)
                    }
                    
                }
                
            }
            .background(
                Image("Image 4")
                                    .resizable()
                                    .scaledToFill()
                                    .edgesIgnoringSafeArea(.all)
//                                    .opacity(0.8) // Adj
                        )
            
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
                        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
                            Text("Owned Business: ")
                                .foregroundColor(.green)
                                .font(.subheadline)
                                .bold()
                            Text("\(ownedBusiness.businessName)")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(8)
                        }
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
                if !businesses.isEmpty {
                    ForEach(businesses, id: \.businessinfo.businessName) { savedBusiness in
                        NavigationLink(destination: BusinessFullContext(business: savedBusiness.businessinfo)) {
                            Text(savedBusiness.businessinfo.businessName)
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                } else {
                    Text("Loading...")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            } else {
                Text("No saved businesses.")
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
                if !events.isEmpty {
                    ForEach(events, id: \.eventID) { event in
                        NavigationLink(destination: EventFullContextView(viewModel: EventFullContextViewModel(event: event))) {
                            Text(event.eventName)
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .padding()
                                    .background(Color.purple)
                                    .cornerRadius(8)
                        }
                    }
                } else {
                    Text("Loading...")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            } else {
                Text("Not attending any events.")
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
