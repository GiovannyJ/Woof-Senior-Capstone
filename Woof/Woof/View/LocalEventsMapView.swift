//
//  LocalEventsMapView.swift
//  Woof
//
//  Created by Giovanny Joseph on 4/1/24.
//

import SwiftUI
import CoreLocation


struct LocalEventsMapView: View {
    @ObservedObject var viewModel = LocalEventsViewModel()
    @ObservedObject var sessionManager = SessionManager.shared

    var defaultCoords = CLLocationCoordinate2D(latitude: 40.7045471, longitude: -73.6687173)
   

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pet-Friendly Events Near You")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()
            
            if let centerCoords = LocationManager.shared.userLocation?.coordinate {
                MapViewUI(centerCoordinate: centerCoords, annotations: viewModel.annotations)
                    .frame(height: 500)
                    .cornerRadius(8)
                    .padding(.top, 10)
            }else{
                Button {
                    LocationManager.shared.requestLocation()
                } label: {
                    Text("Allow location")
                        .padding()
                        .font(.headline)
                        .foregroundColor(Color(.systemBlue))
                }
                .frame(width: UIScreen.main.bounds.width)
                .padding(.horizontal, -32)
                .background(Color.white)
                .clipShape(Capsule())
                .padding()
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchEvents(type: "local")
//            viewModel.updateAnnotations()
        }
        .navigationTitle("Local Events")
    }
}


struct LocalEventsMap_Previews: PreviewProvider {
    static var previews: some View {
        LocalEventsMapView()
    }
}


