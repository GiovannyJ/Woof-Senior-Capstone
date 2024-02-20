//
//  ContentView.swift
//  Woof
//
//  Created by Bo Nappie on 1/5/24.
//

import SwiftUI

struct ContentView: View {
    @State private var counter: Int = 0 // State variable to track the counter value
    @StateObject var sessionManager = SessionManager.shared
    
    
        var body: some View {
            VStack(spacing: 20) { // Vertical stack to arrange views vertically with spacing
                Text("Welcome to Woof!") // Text view greeting message
                    .font(.largeTitle) // Set font size
                    .foregroundColor(.orange) // Set text color
                
                Text("Counter: \(counter)") // Text view displaying the current counter value
                
                Button("Login") { // Button to increment the counter value
                    counter += 1
                }
                .padding()
                .background(Color.teal)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Register"){
                    counter += 2
                }
                .padding() // Add padding to the button
                .background(Color.teal) // Set background color
                .foregroundColor(.white) // Set text color
                .cornerRadius(10) // Set corner radius for rounded corners
            }
            .padding() // Add padding to the VStack
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() // Preview the ContentView
    }
}
