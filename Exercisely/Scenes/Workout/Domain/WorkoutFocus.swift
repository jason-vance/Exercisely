//
//  WorkoutFocus.swift
//  Exercisely
//
//  Created by Jason Vance on 1/7/25.
//

import Foundation

extension Workout {
    class Focus {
        
        static let minTextLength: Int = 1
        static let maxTextLength: Int = 32
        
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

extension Workout.Focus: Identifiable {
    var id: String { value.lowercased() }
}

extension Workout.Focus: Equatable {
    static func == (lhs: Workout.Focus, rhs: Workout.Focus) -> Bool {
        lhs.value.lowercased() == rhs.value.lowercased()
    }
}

extension Workout.Focus: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(value.lowercased())
    }
}

extension Workout.Focus {
    static let prompt: Workout.Focus = .init("Upper Body, Core, etc...")!
    static let sample: Workout.Focus = .init("Legs")!
}
