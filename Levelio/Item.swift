//
//  Item.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 07/04/26.
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
