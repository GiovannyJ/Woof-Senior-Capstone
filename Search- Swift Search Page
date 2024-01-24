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

            Spacer()
        }
        .padding()
        .navigationTitle("Search")
    }

    private func performSearch() {
    
    }
}

// Generates preview of file
struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}

// SearchBar component
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
