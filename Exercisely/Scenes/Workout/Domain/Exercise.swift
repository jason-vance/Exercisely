//
//  Exercise.swift
//  Exercisely
//
//  Created by Jason Vance on 3/12/25.
//

import Foundation

class Exercise {
    
    static let minTextLength: Int = 1
    static let maxTextLength: Int = 64

    private let value: String
    
    init?(_ value: String?) {
        guard let value = value else { return nil }
        
        // Trim whitespace
        let trimmedText = value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check for minimum and maximum length
        guard trimmedText.count >= Self.minTextLength, trimmedText.count <= Self.maxTextLength else {
            return nil
        }
        
        self.value = trimmedText
    }
    
    func formatted() -> String {
        value.capitalized
    }
}

extension Exercise: Identifiable {
    var id: String { value.lowercased() }
}

extension Exercise: Equatable {
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.value.lowercased() == rhs.value.lowercased()
    }
}

extension Exercise: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(value.lowercased())
    }
}

extension Exercise {
    static let prompt: Exercise = .init("Squats, Bench Press, etc...")!
    static let sampleDeadlift: Exercise = .init("Deadlift")!
    static let sampleTreadmill: Exercise = .init("Treadmill")!
    static let sampleYtw: Exercise = .init("YTW")!
    static let sampleArcherPress: Exercise = .init("Archer Press")!
    static let sampleTrxChestStretch: Exercise = .init("TRX Chest Stretch")!
    static let sampleTurkishGetUp: Exercise = .init("Turkish Get-Up")!
    static let sampleShouldersTouches: Exercise = .init("Shoulders Touches")!
    static let sampleKettlebellShoulderPress: Exercise = .init("Kettlebell Shoulder Press")!
    static let sampleMachineShoulderPress: Exercise = .init("Machine Shoulder Press")!
    static let sampleMachineUnderhandRow: Exercise = .init("Machine Underhand Row")!
    static let sampleHike: Exercise = .init("Hike")!
}
