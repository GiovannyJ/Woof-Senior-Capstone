//
//  WoofApp.swift
//  Woof
//
//  Created by Bo Nappie on 1/5/24.
//

import SwiftUI

@main
struct WoofApp: App {
    var body: some Scene {
        WindowGroup {
            Login().environmentObject(SessionManager.shared) // Start directly with the Login view
        }
    }
}
