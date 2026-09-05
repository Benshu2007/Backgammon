//
//  Item.swift
//  Backgammon
//
//  Created by איתי בן שושן on 27/07/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
