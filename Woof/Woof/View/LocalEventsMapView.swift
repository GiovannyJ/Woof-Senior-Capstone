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
            
            MapViewUI(centerCoordinate: defaultCoords, annotations: viewModel.annotations)
                .frame(height: 500)
                .cornerRadius(8)
                .padding(.top, 10)
            
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


