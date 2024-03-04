//
//  updateAccount.swift
//  Woof
//
//  Created by Bo Nappie on 3/4/24.
//

import SwiftUI

struct UpdateAccountView: View {
    @ObservedObject private var sessionManager = SessionManager.shared
    @State private var newUsername: String = ""
    @State private var newEmail: String = ""
    @State private var newPassword: String = ""
    @State private var newProfileImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var errorMessage: String?
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Update Account Information")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()
            
            TextField("New Username", text: $newUsername)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.teal.opacity(0.2))
                .cornerRadius(8)
                .fontWeight(Font.Weight.heavy)
            
            TextField("New Email", text: $newEmail)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.teal.opacity(0.2))
                .cornerRadius(8)
                .fontWeight(Font.Weight.heavy)
            
            SecureField("New Password", text: $newPassword)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.teal.opacity(0.2))
                .cornerRadius(8)
                .fontWeight(Font.Weight.heavy)
            
            Button(action: {
                isShowingImagePicker = true
            }) {
                HStack {
                    Text("Select Profile Picture")
                    if let newProfileImage = newProfileImage {
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
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $newProfileImage, isPresented: $isShowingImagePicker)
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: updateAccount) {
                Text("Update Account")
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

    func updateAccount() {
        // Your update account logic here

        // Dismiss the view after updating account
        presentationMode.wrappedValue.dismiss()
    }
}

struct UpdateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateAccountView()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

