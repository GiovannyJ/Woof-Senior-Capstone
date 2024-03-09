//
//  HomeView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var sessionManager = SessionManager.shared
    @ObservedObject var locationManager = LocationManager.shared
    
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
                    
                    NavigationLink(destination: CreateEventView()) {
                        Text("Create an Event")
                            .fontWeight(.heavy)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.teal)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: RegisterBusinessView(viewModel: RegisterBusinessViewModel())) {
                        Text("Register Your Business")
                            .fontWeight(.heavy)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.teal)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: TestMapView()) {
                        Text("Test Map Page")
                            .fontWeight(.heavy)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.teal)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: TestAddressLookupView()) {
                        Text("Test Address Lookup Page")
                            .fontWeight(.heavy)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.teal)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: LocationRequestView()) {
                        Text("Open Location Request")
                            .fontWeight(.heavy)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

