//
//  DinoStage.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 17/10/26.
//

import Foundation
import SwiftUI

enum DinoStage: Int, CaseIterable, Identifiable {
    case egg = 1
    case hatchling = 2
    case baby = 3
    case adult = 4
    
    var id: Int { rawValue }
    
    var level: Int { rawValue }
    
    var name: String {
        switch self {
        case .egg:
            return "Egg"
        case .hatchling:
            return "Hatchling"
        case .baby:
            return "Baby Dino"
        case .adult:
            return "Adult Dino"
        }
    }
    
    var imageName: String {
        switch self {
        case .egg:
            return "dino-egg-blue"
        case .hatchling:
            return "dino-hatch-blue"
        case .baby:
            return "dino-baby-blue"
        case .adult:
            return "dino-adult-blue"
        }
    }
    
    var speechBubbleText: String {
        switch self {
        case .egg:
            return "Hatch me!"
        case .hatchling:
            return "Growing up!"
        case .baby:
            return "Almost there!"
        case .adult:
            return "Maximum Power!"
        }
    }
    
    var minXP: Int {
        switch self {
        case .egg:
            return 0
        case .hatchling:
            return 400
        case .baby:
            return 1000
        case .adult:
            return 2000
        }
    }
    
    var targetXP: Int {
        switch self {
        case .egg:
            return 400
        case .hatchling:
            return 1000
        case .baby:
            return 2000
        case .adult:
            return 2000
        }
    }
    
    var isMaxLevel: Bool {
        self == .adult
    }
    
    var nextStage: DinoStage? {
        DinoStage(rawValue: rawValue + 1)
    }
    
    static func stage(for xp: Int) -> DinoStage {
        if xp < 400 {
            return .egg
        } else if xp < 1000 {
            return .hatchling
        } else if xp < 2000 {
            return .baby
        } else {
            return .adult
        }
    }
    
    func progressRatio(for totalXP: Int) -> Double {
        if isMaxLevel {
            return 1.0
        }
        guard targetXP > 0 else { return 0.0 }
        let ratio = Double(totalXP) / Double(targetXP)
        return min(1.0, max(0.0, ratio))
    }
    
    func remainingXP(for totalXP: Int) -> Int {
        if isMaxLevel {
            return 0
        }
        return max(0, targetXP - totalXP)
    }
}
