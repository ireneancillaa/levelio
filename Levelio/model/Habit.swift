//
//  Habit.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 14/09/26.
//

import Foundation

struct Habit: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var description: String
    var colorName: String
    var frequency: String
    var time: String
    var isCompleted: Bool = false
    var xpReward: Int = 50
    var createdAt: Date = Date()
}
