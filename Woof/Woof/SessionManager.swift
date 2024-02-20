//
//  SessionManager.swift
//  Woof
//
//  Created by Giovanny Joseph on 2/4/24.
//

import Foundation
import SwiftUI
import Combine

class SessionManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn: Bool = false
    @Published var userID: Int?
    
    static let shared = SessionManager()
    
    private init() {}
    
    func getUserID() -> Int? {
        return userID
    }
}
