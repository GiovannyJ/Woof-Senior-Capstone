//  HomeView.swift
//  Woof
//
//  Created by Bo Nappie on 1/23/24.
//

//import SwiftUI
//
//struct HomeView: View {
//    @ObservedObject private var sessionManager = SessionManager.shared
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 16) {
//                    Text("Welcome Back \(sessionManager.currentUser?.username ?? "Guest")!")
//                        .font(.subheadline)
//                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                        .padding(.leading)
//                    
//                    Text("Discover Pet-Friendly Businesses and Events.")
//                        .font(.largeTitle)
//                        .foregroundColor(.orange)
//                        .padding()
//
//                    Text("Features:")
//                        .font(.callout)
//                        .fontWeight(.bold)
//                        .padding(.leading)
//
//                    NavigationLink(destination: Profile()) {
//                        Text("Profile")
//                            .font(.subheadline)
//                            .fontWeight(.heavy)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.teal)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//
//                    NavigationLink(destination: Search()) {
//                        Text("Search Businesses")
//                            .fontWeight(.heavy)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.teal)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//
//                    NavigationLink(destination: LocalEvents()) {
//                        Text("Local Events")
//                            .fontWeight(.heavy)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.teal)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    
//                    NavigationLink(destination: CreateEventView()) {
//                        Text("Create an Event")
//                            .fontWeight(.heavy)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.teal)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    
//                    NavigationLink(destination: RegisterBusiness()) {
//                        Text("Register Your Business")
//                            .fontWeight(.heavy)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.teal)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }                    // Add more features as needed
//
//                    Spacer()
//                }
//                .padding()
//            }
//            .navigationTitle("Home")
//        }
//    }
//}
//
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
