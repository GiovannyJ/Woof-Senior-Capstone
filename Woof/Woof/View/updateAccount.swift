//
//  updateAccount.swift
//  Woof
//
//  Created by Bo Nappie on 3/4/24.
//

import SwiftUI

struct UpdateAccountView: View {
    @ObservedObject private var viewModel: UpdateAccountViewModel
    
    // Initialize the view model with the current user's username and email
    init() {
        self.viewModel = UpdateAccountViewModel()
        if let currentUser = viewModel.sessionManager.currentUser {
            viewModel.newUsername = currentUser.username
            viewModel.newEmail = currentUser.email
        }
    }
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Update Account Information")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                    .padding()
                
                
                TextField("New Username", text: $viewModel.newUsername)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.teal.opacity(0.2))
                    .cornerRadius(8)
                    .fontWeight(Font.Weight.heavy)
                
                TextField("New Email", text: $viewModel.newEmail)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.teal.opacity(0.2))
                    .cornerRadius(8)
                    .fontWeight(Font.Weight.heavy)
                
                Button(action: {
                    viewModel.selectProfilePicture()
                }) {
                    HStack {
                        Text("Select Profile Picture")
                        if let newProfileImage = viewModel.newProfileImage {
                            Image(uiImage: newProfileImage)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    .background(Color.teal.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
                .sheet(isPresented: $viewModel.isShowingImagePicker) {
                    ImagePicker(image: $viewModel.newProfileImage, isPresented: $viewModel.isShowingImagePicker, didSelectImage: viewModel.imagePickerDidSelectImage)
                }
                
                Button(action: {
                    updateAccount()
                }) {
                    Text("Update Account")
                        .padding()
                        .background(Color.orange.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                Section(header: Text("Update Password")){
                    SecureField("Old Password", text: $viewModel.oldPassword)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal.opacity(0.2))
                        .cornerRadius(8)
                        .fontWeight(Font.Weight.heavy)
                    
                    
                    SecureField("New Password", text: $viewModel.newPassword)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal.opacity(0.2))
                        .cornerRadius(8)
                        .fontWeight(Font.Weight.heavy)
                }
                
                
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                Button(action: {
                    updatePassword()
                }) {
                    Text("Update Password")
                        .padding()
                        .background(Color.orange.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                
            }
            .padding()
            .navigationTitle("Update Account")
        }
    }
    
    func updateAccount() {
        viewModel.updateAccount { isSuccess in
            if isSuccess {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    func updatePassword() {
        viewModel.updatePassword {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct UpdateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateAccountView()
    }
}

