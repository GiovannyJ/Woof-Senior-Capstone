//
//  WoofApp.swift
//  Woof
//
//  Created by Bo Nappie on 1/5/24.
//

import SwiftUI
import CoreLocation
import MapKit

@main
struct WoofApp: App {
    var body: some Scene {
        WindowGroup {
//            MapTestThing()
            LoginView().environmentObject(SessionManager.shared)
//            ContentView().locationManager(// Start directly with the Login view
        }
    }
}

