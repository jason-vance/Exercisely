//
//  ExerciseName.swift
//  Exercisely
//
//  Created by Jason Vance on 3/12/25.
//

import Foundation

extension Workout.Exercise {
    struct Name {
        
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
}

extension Workout.Exercise.Name: Identifiable {
    var id: String { value.lowercased() }
}

extension Workout.Exercise.Name: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value.lowercased() == rhs.value.lowercased()
    }
}

extension Workout.Exercise.Name: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(value.lowercased())
    }
}

extension Workout.Exercise.Name: Codable { }

extension Workout.Exercise.Name {
    static let prompt: Self = .init("Squats, Bench Press, etc...")!
    static let sampleDeadlift: Self = .init("Deadlift")!
    static let sampleTreadmill: Self = .init("Treadmill")!
    static let sampleYtw: Self = .init("YTW")!
    static let sampleArcherPress: Self = .init("Archer Press")!
    static let sampleTrxChestStretch: Self = .init("TRX Chest Stretch")!
    static let sampleTurkishGetUp: Self = .init("Turkish Get-Up")!
    static let sampleShouldersTouches: Self = .init("Shoulders Touches")!
    static let sampleKettlebellShoulderPress: Self = .init("Kettlebell Shoulder Press")!
    static let sampleMachineShoulderPress: Self = .init("Machine Shoulder Press")!
    static let sampleMachineUnderhandRow: Self = .init("Machine Underhand Row")!
    static let sampleHike: Self = .init("Hike")!
    static let sampleBenchPress: Self = .init("Bench Press")!
    static let samplePushUps: Self = .init("Push-Ups")!
}
