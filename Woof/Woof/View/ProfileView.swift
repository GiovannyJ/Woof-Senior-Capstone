//
//  ProfileView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel = ProfileViewModel()
    @ObservedObject var sessionManager = SessionManager.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                if let profileImage = sessionManager.profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 2)) // Draw black outline
                        .padding()
                } else {
                    ProgressView() // Show loading indicator while fetching image
                        .padding()
                }
                Text("User Profile")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                    .padding()
                
                Section(header: Text("User Information")) {
                    Text("Username: \(SessionManager.shared.currentUser?.username ?? "Guest")")
                    Text("Email: \(SessionManager.shared.currentUser?.email ?? "Guest")")
                    
                    if(SessionManager.shared.isBusinessOwner){
                        Text("Owned Business: ")
                        if let ownedBusiness = SessionManager.shared.ownedBusiness {
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
                }
                
                Section(header: Text("Saved Businesses")) {
                    if let businesses = SessionManager.shared.savedBusinesses {
                        if businesses.isEmpty {
                            Text("No saved businesses.")
                        } else {
                            ForEach(businesses, id: \.businessinfo.businessName) { savedBusiness in
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
                    if let events = SessionManager.shared.eventsAttending {
                        if events.isEmpty {
                            Text("Not attending any events.")
                        } else {
                            ForEach(events, id: \.eventID) { event in
                                NavigationLink(destination: EventFullContextView(viewModel: EventFullContextViewModel(event: event))) {
                                    Text(event.eventName)
                                        .padding()
                                        .background(Color.purple)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    } else {
                        Text("Not attending any events.").foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Profile")
        .onAppear {
            //            viewModel.fetchSavedBusinesses()
            //            viewModel.fetchProfileImage()
            //            SessionManager.shared.fetchEventsAttending()
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
