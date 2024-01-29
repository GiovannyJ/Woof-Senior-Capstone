//  RegisterView.swift
//  Woof
//
//  Created by Bo Nappie on 1/5/24.
//

import SwiftUI

struct RegisterView: View {
    // variables to store user input for registration
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var accountType: String = ""

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

                // Email text field
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.teal.opacity(0.2))
                    .cornerRadius(8)

                // Account Type text field
                TextField("Account Type", text: $accountType)
                    .padding()
                    .background(Color.teal.opacity(0.2))
                    .cornerRadius(8)

                // Register button
                Button(action: {
                    // Implement registration logic here
                    // You can perform validation and insert data into the user table
                    // For simplicity, this example assumes that the registration is successful

                    print("Registration successful")
                    // You might want to navigate to the login page or perform other actions
                }) {
                    Text("Register")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal)
                        .cornerRadius(8)
                        .fontWeight(Font.Weight.heavy)
                }
                .padding(.horizontal)

                .padding()
                .navigationTitle("Register")
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
