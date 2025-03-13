//
//  Item.swift
//  Exercisely
//
//  Created by Jason Vance on 1/7/25.
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
