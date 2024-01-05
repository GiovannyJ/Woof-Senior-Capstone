//
//  login.swift
//  Woof
//
//  Created by Bo Nappie on 1/5/24.
//

import SwiftUI

struct login: View {
    // variables to store user input for username and password
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Username text field
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.teal.opacity(0.2))
                    .cornerRadius(8)
                
                // Password secure field
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.teal.opacity(0.2))
                    .cornerRadius(8)
                
                // Login button
                Button(action: {
                    // Implement authentication logic here using ex
                    if username == "admin" && password == "password" {
                        print("Login successful")
                        // Navigate to the main content view or perform other actions
                    } else {
                        print("Invalid credentials")
                        // Display error message or handle authentication failure
                    }
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
            }
        }
    }
    
    
    struct Login_Previews: PreviewProvider {
        static var previews: some View {
            login()
        }
    }
}
