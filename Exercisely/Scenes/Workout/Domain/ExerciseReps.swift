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
        
        func subtracting(_ other: Reps) -> Reps? {
            return subtracting(other.value)
        }
        
        func subtracting(_ value: Int) -> Reps? {
            .init(self.value - value)
        }
        
        func adding(_ other: Reps) -> Reps {
            return adding(other.value)
        }
        
        func adding(_ value: Int) -> Reps {
            .init(self.value + value)!
        }
        
        func formatted() -> String {
            "\(value)reps"
        }
        
        static func formatted(_ reps: [Reps?]) -> String {
            guard !reps.compactMap(\.self).isEmpty else { return "??reps" }
            guard reps.count > 1 else { return reps[0]?.formatted() ?? "???" }
            
            let allAreSameValue = Set(reps.map({ $0?.value })).count == 1
            if allAreSameValue {
                return reps[0]?.formatted() ?? "????"
            } else {
                let valuesString = reps.map({ "\($0 == nil ? "-" : "\($0!.value)")" }).joined(separator: ",")
                return "\(valuesString)reps"
            }
        }
    }
}

extension Workout.Exercise.Reps: Equatable {
    static func == (lhs: Workout.Exercise.Reps, rhs: Workout.Exercise.Reps) -> Bool {
        lhs.value == rhs.value
    }
}

extension Workout.Exercise.Reps: Comparable {
    public static func < (lhs: Workout.Exercise.Reps, rhs: Workout.Exercise.Reps) -> Bool {
        lhs.count < rhs.count
    }
}

extension Workout.Exercise.Reps: Codable { }
