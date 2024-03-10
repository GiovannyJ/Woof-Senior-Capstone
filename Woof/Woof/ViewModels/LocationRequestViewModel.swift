//
//  LocationRequestView.swift
//  MapboxTestv4
//
//  Created by Martin on 2/18/24.
//

import SwiftUI

// This struct defines the LocationRequestView, which is a SwiftUI view prompting the user to allow location access.
struct LocationRequestViewModel: View {
    var body: some View {
        // ZStack places views on top of each other in the z-axis.
        ZStack {
                
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


// This struct provides a preview of the LocationRequestViewModel.
struct LocationRequestViewModel_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestViewModel() // Shows the LocationRequestView in the preview.
    }
}
