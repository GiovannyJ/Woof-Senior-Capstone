//  ProfileView.swift
//  Woof
//
//  Created by Bo Nappie on 1/23/24.
//

import SwiftUI

struct Profile: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("User Profile")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()

            // Display user information, history, saved businesses, and reviews
            ScrollView {
                Section(header: Text("User Information")) {
                    Text("Username: GioJoJo")
                    Text("Email: Gio.doe@example.com")
                   
                }

                Section(header: Text("History")) {
                    // Display activity history
                    Text("No history available.")
                }

                Section(header: Text("Saved Businesses")) {
                    // Display businesses saved by the user
                    Text("No saved businesses.")
                }

                Section(header: Text("Reviews")) {
                    // Display user's reviews
                    Text("No reviews submitted.")
                }
            }
        }
        .padding()
        .navigationTitle("Profile")
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
