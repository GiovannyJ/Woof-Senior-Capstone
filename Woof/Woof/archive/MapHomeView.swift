//
//  MapHomeView.swift
//  Woof
//
//  Created by Martin on 3/28/24.
//

import SwiftUI
import MapKit

struct newView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        // Update the view
    }
}

struct MapHomeView: View {
    @ObservedObject private var sessionManager = SessionManager.shared
    @ObservedObject private var locationManager = LocationManager.shared
//    @StateObject private var mapAPI = MapAPI()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    MapViewModel()
                        .frame(height: 200) // Adjust height as needed
                    
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
                        
//                        NavigationLink(destination: UpdateBusinessView()) {
//                            Text("Update Your Business")
//                                .fontWeight(.heavy)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(Color.red)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                        }
                    }
                }
                    
//                    NavigationLink(destination:
//                                    AddressFinderView()) {
//                        Text("Test address look up")
//                            .fontWeight(.heavy)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    NavigationLink(destination:
//                                    MapView()) {
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
            .onAppear{
                locationManager.startUpdatingLocation()
            }
        }
    }


struct MapHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MapHomeView()
    }
}

    
