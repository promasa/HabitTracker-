//
//  Item.swift
//  HabitTracker
//
//  Created by 渡邉征宏 on 2026/07/02.
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
