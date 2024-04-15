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
            NavigationStack {
                VStack{
                    Image("Image 2")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: UIScreen.main.bounds.height * 0.33)
                        .clipped()
                        .padding(.bottom, 50)
                    
                    TextField("Username", text: $viewModel.username)
                        .disableAutocorrection(true)
                        .textContentType(.none)
                        .padding()
                        .background(Color.teal.opacity(0.2))
                        .cornerRadius(8)
                        
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color.teal.opacity(0.2))
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
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
                    }
                    
                    NavigationLink(
                        destination: RegisterAccountView(),
                        label: {
                            Text("Don't have an account? Sign Up!")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.red)
                                .padding(.leading)
                                .underline()
                        })
//                    .padding(.bottom)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                            .opacity(1.0)
                    }
                }
                .padding(.horizontal)
                .padding(.top , -150)
//                .navigationTitle("Login")
                .navigationDestination(
                    isPresented: $viewModel.isLoggedIn) {
                        HomeView()
                    }
            }
            .background(
                Color.white.opacity(0.4)
            )
//            .padding(.top, -150)
        }
    }

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
