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

    @State private var annotations: [CustomAnnotation] = []
    var defaultCoords = CLLocationCoordinate2D(latitude: 40.7045471, longitude: -73.6687173)
    init(){
        viewModel.fetchEvents(type: "local")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pet-Friendly Events Near You")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()
            
            MapViewUI(centerCoordinate: defaultCoords)
                .frame(height: 500)
                .cornerRadius(8)
                .padding(.top, 10)
            
        }
        .padding()
        .onAppear {

            updateAnnotations()
        }
        .navigationTitle("Local Events")
    }
    
    private func updateAnnotations() {
        annotations.removeAll()
        for event in viewModel.events {
            if let coordinates = ParseCoordinates(from: event.geolocation) {
                let annotation = CustomAnnotation(coordinate: coordinates, title: event.eventName + "\n" + event.location)
                annotations.append(annotation)
                MapViewUI.mapView.addAnnotation(annotation)
            }
        }
    }
}


struct LocalEventsMap_Previews: PreviewProvider {
    static var previews: some View {
        LocalEventsMapView()
    }
}


