//
//  Item.swift
//  Flow
//
//  Created by Jonathan Gonzalez on 4/23/26.
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
