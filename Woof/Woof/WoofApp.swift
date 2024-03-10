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
            LoginView().environmentObject(SessionManager.shared) // Start directly with the Login view
        }
    }
}
