//
//  SearchViewModel.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import Foundation
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var businesses: [Business] = []
    @Published var isEmpty: Bool = false

    func performSearch(keyword: String) {
        // Define the URL
        guard var urlComponents = URLComponents(string: "http://localhost:8080/businesses") else {
            print("Invalid URL")
            return
        }

        // Add query parameters
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "businessName", value: keyword))
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            print("Invalid URL")
            return
        }

        // Perform the request
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data")
                self.isEmpty = true
                return
            }

            do {
                // Parse JSON response into an array of Business objects
                let decodedResponse = try JSONDecoder().decode([Business].self, from: data)
                DispatchQueue.main.async {
                    self.businesses = decodedResponse
                    self.isEmpty = false
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}
