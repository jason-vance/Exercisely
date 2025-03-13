//
//  ExerciseName.swift
//  Exercisely
//
//  Created by Jason Vance on 3/12/25.
//

import Foundation

class ExerciseName {
    
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
        value
    }
}

extension ExerciseName: Identifiable {
    var id: String { value.lowercased() }
}

extension ExerciseName: Equatable {
    static func == (lhs: ExerciseName, rhs: ExerciseName) -> Bool {
        lhs.value.lowercased() == rhs.value.lowercased()
    }
}

extension ExerciseName: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(value.lowercased())
    }
}

extension ExerciseName {
    static let prompt: ExerciseName = .init("Squats, Bench Press, etc...")!
    static let sampleDeadlift: ExerciseName = .init("Deadlift")!
    static let sampleTreadmill: ExerciseName = .init("Treadmill")!
    static let sampleYtw: ExerciseName = .init("YTW")!
    static let sampleArcherPress: ExerciseName = .init("Archer Press")!
    static let sampleTrxChestStretch: ExerciseName = .init("TRX Chest Stretch")!
    static let sampleTurkishGetUp: ExerciseName = .init("Turkish Get-Up")!
    static let sampleShouldersTouches: ExerciseName = .init("Shoulders Touches")!
    static let sampleKettlebellShoulderPress: ExerciseName = .init("Kettlebell Shoulder Press")!
    static let sampleMachineShoulderPress: ExerciseName = .init("Machine Shoulder Press")!
    static let sampleMachineUnderhandRow: ExerciseName = .init("Machine Underhand Row")!
    static let sampleHike: ExerciseName = .init("Hike")!
}
