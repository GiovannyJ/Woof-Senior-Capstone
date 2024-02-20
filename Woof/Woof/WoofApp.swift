//
//  WoofApp.swift
//  Woof
//
//  Created by Bo Nappie on 1/5/24.
//

import SwiftUI

@main
struct WoofApp: App {
    @StateObject var sessionManager = SessionManager.shared
    var body: some Scene {
        WindowGroup {
            Login().environmentObject(sessionManager) // Start directly with the Login view
        }
    }
}
