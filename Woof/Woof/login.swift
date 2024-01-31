//
//  login.swift
//  Woof
//
//  Created by Bo Nappie on 1/5/24.
//

import SwiftUI

struct Login: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Username", text: $username)
                    .disableAutocorrection(true)
                    .textContentType(.none)
                    .padding()
                    .background(Color.teal.opacity(0.2))
                    .cornerRadius(8)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.teal.opacity(0.2))
                    .cornerRadius(8)

                Button(action: {
                    // Make API request
                    authenticateUser()
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal)
                        .cornerRadius(8)
                        .fontWeight(Font.Weight.heavy)
                }
                .padding(.horizontal)
                .padding()
                .navigationTitle("Login")

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
            }
        }
    }

    private func authenticateUser() {
        let url = URL(string: "http://localhost:8080/login")!

        let body: [String: String] = [
            "username": username,
            "password": password
        ]

        let jsonData = try? JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 201:
                    // Successful response
                    do {
                        let decodedData = try JSONDecoder().decode([User].self, from: data!)
                        print(decodedData)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                case 500:
                    // Handle 500 error
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data!)
                        errorMessage = errorResponse.error
                    } catch {
                        print("Error decoding error JSON: \(error)")
                        errorMessage = "Internal Server Error"
                    }
                default:
                    // Handle other status codes
                    errorMessage = "Unexpected error occurred"
                }
            }
        }.resume()
    }
}

struct ErrorResponse: Decodable {
    let error: String
}

struct User: Decodable {
    let userID: Int
    let username: String
    let pwd: String
    let email: String
    let accountType: String
    let imgID: ImageID
}

struct ImageID: Decodable {
    let Int64: Int
    let Valid: Bool
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
