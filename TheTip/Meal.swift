//
//  Item.swift
//  TheTip
//
//  Created by Trey Gaines on 1/10/24.
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
