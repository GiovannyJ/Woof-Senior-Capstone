//
//  HomeView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct HomeView: View {
    @ObservedObject private var sessionManager = SessionManager.shared
    @ObservedObject private var locationManager = LocationManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Welcome Back \(sessionManager.currentUser?.username ?? "Guest")!")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    Text("Discover Pet-Friendly Businesses and Events.")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                        .padding()

                    Text("Features:")
                        .font(.callout)
                        .fontWeight(.bold)
                        .padding(.leading)

                    NavigationLink(destination: ProfileView()) {
                        Text("Profile")
                            .font(.subheadline)
                            .fontWeight(.heavy)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.teal)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: SearchView()) {
                        Text("Search Businesses")
                            .fontWeight(.heavy)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.teal)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: LocalEventsView()) {
                        Text("Local Events")
                            .fontWeight(.heavy)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.teal)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                        NavigationLink(destination: UpdateAccountView()) {
                            Text("Update Profile")
                                .fontWeight(.heavy)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    
                    // Buttons for business user
                    if sessionManager.currentUser?.accountType == "business" && !sessionManager.isBusinessOwner {
                        NavigationLink(destination: RegisterBusinessView()) {
                            Text("Register Your Business")
                                .fontWeight(.heavy)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.teal)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }else if sessionManager.isBusinessOwner{
                            NavigationLink(destination: CreateEventView()) {
                                Text("Create an Event")
                                    .fontWeight(.heavy)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.teal)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            
                            
                            NavigationLink(destination: UpdateEventsListView()) {
                                Text("Update Your Events")
                                    .fontWeight(.heavy)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            
                            NavigationLink(destination: UpdateBusinessView()) {
                                Text("Update Your Business")
                                    .fontWeight(.heavy)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    
//                    NavigationLink(destination: 
//                        AddressFinderView()) {
//                        Text("Test address look up")
//                            .fontWeight(.heavy)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    NavigationLink(destination: 
//                        MapView()) {
//                        Text("Test map view")
//                            .fontWeight(.heavy)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    NavigationLink(destination: LocationRequestView()) {
//                        Text("Do this first")
//                            .fontWeight(.heavy)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

