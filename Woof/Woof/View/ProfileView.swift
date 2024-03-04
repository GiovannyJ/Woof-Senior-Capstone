//
//  ProfileView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel = ProfileViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let profileImage = viewModel.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()
            } else {
                ProgressView() // Show loading indicator while fetching image
                    .padding()
            }
            Text("User Profile")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()

            // Display user information, history, saved businesses, and reviews
            ScrollView {
                Section(header: Text("User Information")) {
                    Text("Username: \(viewModel.sessionManager.currentUser?.username ?? "Guest")")
                    Text("Email: \(viewModel.sessionManager.currentUser?.email ?? "Guest")")
                    Text("Owned Business: ")
                    if let ownedBusiness = viewModel.sessionManager.ownedBusiness {
                        NavigationLink(destination: BusinessFullContext(business: ownedBusiness)) {
                            Text(ownedBusiness.businessName)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    } else {
                        Text("None").foregroundColor(.gray)
                    }
                }

                Section(header: Text("Saved Businesses")) {
                    if let businesses = viewModel.savedBusinesses {
                        if businesses.isEmpty {
                            Text("No saved businesses.")
                        } else {
                            ForEach(businesses, id: \.businessinfo.businessID) { savedBusiness in
                                NavigationLink(destination: BusinessFullContext(business: savedBusiness.businessinfo)) {
                                    Text(savedBusiness.businessinfo.businessName)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    } else {
                        Text("No saved businesses.").foregroundColor(.gray)
                    }
                }
                Section(header: Text("Events Attending")) {
                    if let events = viewModel.eventsAttending {
                        if events.isEmpty {
                            Text("Not attending any events.")
                        } else {
                            ForEach(events, id: \.eventID) { event in // Use \.eventID directly for id
                                NavigationLink(destination: EventFullContextView(event: event)) {
                                    Text(event.eventName)
                                        .padding()
                                        .background(Color.purple)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    } else {
                        Text("Loading events...").foregroundColor(.gray)
                    }
                }

            }
        }
        .padding()
        .navigationTitle("Profile")
        .onAppear {
            viewModel.fetchSavedBusinesses()
            viewModel.fetchProfileImage()
            viewModel.fetchEventsAttending()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
