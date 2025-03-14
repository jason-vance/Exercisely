//
//  ExerciseReps.swift
//  Exercisely
//
//  Created by Jason Vance on 3/12/25.
//

import Foundation

extension Workout.Exercise {
    struct Reps {
        
        private let value: Int
        
        init?(_ value: Int) {
            guard value > 0 else { return nil }
            self.value = value
        }
        
        var count: Int { value }
        
        func formatted() -> String {
            "\(value)reps"
        }
    }
}

extension Workout.Exercise.Reps: Equatable {
    static func == (lhs: Workout.Exercise.Reps, rhs: Workout.Exercise.Reps) -> Bool {
        lhs.value == rhs.value
    }
}

extension Workout.Exercise.Reps: Codable { }
