//
//  LocationRequestView.swift
//  MapboxTestv4
//
//  Created by Martin on 2/18/24.
//

import SwiftUI

// This struct defines the LocationRequestView, which is a SwiftUI view prompting the user to allow location access.
struct LocationRequestView: View {
    var body: some View {
        // ZStack places views on top of each other in the z-axis.
        ZStack {
            // Background color of system blue that ignores safe area insets.
            Color(.systemBlue).ignoresSafeArea()
            
            // VStack arranges views vertically.
            VStack {
                Spacer() // Spacer expands to fill available space.
                
                // Image of a paper plane with circle fill.
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 32) // Adds bottom padding.
                
                // Text prompting the user to explore nearby places.
                Text("Would you like to explore places nearby?")
                    .font(.system(size:28, weight: . semibold)) // Sets font style.
                    .multilineTextAlignment(.center) // Centers text alignment.
                    .padding() // Adds padding around the text.
                
                // Text informing the user to start sharing their location.
                Text("Start sharing your location with us")
                    .multilineTextAlignment(.center) // Centers text alignment.
                    .frame(width: 140) // Sets frame width.
                    .padding() // Adds padding around the text.
                
                Spacer() // Spacer expands to fill available space.
                
                // VStack arranges views vertically.
                VStack {
                    // Button to allow location access when tapped.
                    Button {
                        LocationManager.shared.requestLocation() // Requests location access.
                    } label: {
                        Text("Allow location") // Button label text.
                            .padding() // Adds padding around the text.
                            .font(.headline) // Sets font style.
                            .foregroundColor(Color(.systemBlue)) // Sets text color.
                    }
                    .frame(width: UIScreen.main.bounds.width) // Sets button width.
                    .padding(.horizontal, -32) // Adds negative horizontal padding.
                    .background(Color.white) // Sets button background color.
                    .clipShape(Capsule()) // Clips button shape to a capsule.
                    .padding() // Adds padding around the button.
                    
                    // Button to dismiss location request when tapped.
                    Button {
                        print("Dismiss") // Prints a message when tapped.
                    } label: {
                        Text("Maybe later") // Button label text.
                            .padding() // Adds padding around the text.
                            .font(.headline) // Sets font style.
                            .foregroundColor(.white) // Sets text color.
                    }
                }
                .padding(.bottom, 32) // Adds bottom padding.
            }
            .foregroundColor(.white) // Sets foreground color of text.
        }
    }
}

// This struct provides a preview of the LocationRequestView.
struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView() // Shows the LocationRequestView in the preview.
    }
}

