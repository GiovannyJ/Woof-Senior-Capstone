//
//  LoginView.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/22/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var viewModel = LoginViewModel()
    @State private var showingAlert = false

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack(spacing: 13.0) {
                    TextField("Username", text: $viewModel.username)
                        .disableAutocorrection(true)
                        .textContentType(.none)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    
                    Button(action: {
                        viewModel.authenticateUser()
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
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
                    }
                    
                    NavigationLink(
                        destination: RegisterAccountView(),
                        label: {
                            Text("Don't have an account? Sign Up")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.red)
                                .padding(.leading)
                        })
                        .padding(.bottom)
                        .opacity(1.0) // Ensure full opacity
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                            .opacity(1.0) // Ensure full opacity
                    }
                }
                .padding(.horizontal)
                .navigationTitle("Login")
                .navigationDestination(
                    isPresented: $viewModel.isLoggedIn) {
                        HomeView()
                    }
            }
            .background(
                Color.white.opacity(1.0) // Ensure full opacity
            )
            .overlay(
                Image("Image 1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.3)
            )
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
