//  SearchView.swift
//  Woof
//
//  Created by Bo Nappie on 1/23/24.
//

import SwiftUI

struct Search: View {
    @State private var searchKeyword: String = ""
    @State private var filterByHotel: Bool = false
    @State private var filterByRestaurant: Bool = false
    @State private var selectedBusinessType: String = "All"
    @State private var businesses: [Business] = []

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
                performSearch()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.teal)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.top, 16)

            // Business buttons
            VStack(alignment: .leading, spacing: 8) {
                ForEach(businesses, id: \.businessID) { business in
                    Button(action: {
                        // Navigate to BusinessReviews with selected business
                        let businessReviews = BusinessReviews(business: business)
                        UIApplication.shared.windows.first?.rootViewController?.present(UIHostingController(rootView: businessReviews), animated: true)
                    }) {
                        BusinessButton(business: business)
                    }
                }
            }
            .padding(.top, 16)

            Spacer()
        }
        .padding()
        .navigationTitle("Search")
        .sheet(isPresented: .constant(false)) {
            EmptyView()
        }
    }

    private func performSearch() {
        // Define the URL
        guard var urlComponents = URLComponents(string: "http://localhost:8080/businesses") else {
            print("Invalid URL")
            return
        }

        // Add query parameters
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "businessName", value: searchKeyword))
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            print("Invalid URL")
            return
        }

        // Perform the request
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data")
                return
            }

            do {
                // Parse JSON response into an array of Business objects
                let decodedResponse = try JSONDecoder().decode([Business].self, from: data)
                DispatchQueue.main.async {
                    self.businesses = decodedResponse
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

// Generates preview of file
struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}

// BusinessButton component
struct BusinessButton: View {
    let business: Business

    var body: some View {
        VStack(alignment: .leading) {
            Text(business.businessName)
                .font(.headline)
            Text("Type: \(business.businessType)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Location: \(business.location)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.teal.opacity(0.1))
        .cornerRadius(8)
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .padding(.horizontal, 24)
                .background(Color.teal.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                            .padding(.trailing, 4)
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
        }
    }
}

