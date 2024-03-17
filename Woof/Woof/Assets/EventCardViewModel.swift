//
//  EventCardViewModel.swift
//  Woof
//
//  Created by Giovanny Joseph on 3/17/24.
//

import Foundation
import SwiftUI

class EventCardViewModel: ObservableObject {
    let event: Event
    @Published var isAttending: Bool
    let type: String
    
    init(event: Event, isAttending: Bool, type: String) {
        self.event = event
        self.isAttending = isAttending
        self.type = type
    }
    
    
}
