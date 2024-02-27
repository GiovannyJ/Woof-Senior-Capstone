//
//  SearchView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchKeyword: String = ""
    @State private var filterByHotel: Bool = false
    @State private var filterByRestaurant: Bool = false
    @State private var selectedBusinessType: String = "All"
    @ObservedObject private var viewModel = SearchViewModel()

    // Array for business types
    let businessTypes = ["All", "Hotel", "Restaurant", "Daycare", "Park", "Other"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Search for Pet-Friendly Businesses")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()

            // SearchBar
            SearchBar(text: $searchKeyword)

            // Business Type Picker
            Picker("Select Business Type", selection: $selectedBusinessType) {
                ForEach(businessTypes, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color.teal.opacity(0.2))
            .cornerRadius(8)

            // Filters
            Toggle("Hotels", isOn: $filterByHotel)
            Toggle("Restaurants", isOn: $filterByRestaurant)

            // Search button
            Button("Search") {
                viewModel.performSearch(keyword: searchKeyword)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.teal)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.top, 16)
            if viewModel.isEmpty {
                Text("No results found")
                    .foregroundColor(.red)
                    .padding(.top, 16)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.businesses, id: \.businessID) { business in
                        Button(action: {
                            // Navigate to BusinessReviews with selected business
                            let businessReviews = BusinessFullContext(business: business)
                            UIApplication.shared.windows.first?.rootViewController?.present(UIHostingController(rootView: businessReviews), animated: true)
                        }) {
                            BusinessButton(business: business)
                        }
                    }
                }
                .padding(.top, 16)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Search")
        .sheet(isPresented: .constant(false)) {
            EmptyView()
        }
    }
}

// Generates preview of file
struct Search_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}