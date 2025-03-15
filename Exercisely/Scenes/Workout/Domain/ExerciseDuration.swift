//
//  ExerciseDuration.swift
//  Exercisely
//
//  Created by Jason Vance on 3/12/25.
//

import Foundation

extension Workout.Exercise {
    struct Duration {
        
        private static let secsPerMin: Double = 60
        private static let minsPerHour: Double = 60
        private static let precision: Int = 4
        
        private static let conversionTable: Dictionary<Unit, Dictionary<Unit, Double>> = [
            .seconds: [
                .seconds: 1,
                .minutes: 1 / Self.secsPerMin,
                .hours: 1 / Self.secsPerMin / Self.minsPerHour
            ],
            .minutes: [
                .seconds: Self.secsPerMin,
                .minutes: 1,
                .hours: 1 / Self.minsPerHour
            ],
            .hours: [
                .seconds: Self.minsPerHour * Self.secsPerMin,
                .minutes: Self.minsPerHour,
                .hours: 1
            ]
        ]
        
        enum Unit: Codable {
            case seconds
            case minutes
            case hours
            
            func formatted() -> String {
                switch self {
                case .seconds: return "s"
                case .minutes: return "m"
                case .hours: return "h"
                }
            }
        }
        
        let value: Double
        let unit: Unit
        
        init?(value: Double, unit: Unit) {
            guard value >= 0 else { return nil }
            self.value = value
            self.unit = unit
        }
        
        static func seconds(_ value: Double) -> Self? {
            .init(value: value, unit: .seconds)
        }
        
        static func minutes(_ value: Double) -> Self? {
            .init(value: value, unit: .minutes)
        }
        
        static func hours(_ value: Double) -> Self? {
            .init(value: value, unit: .hours)
        }
        
        func formatted() -> String {
            "\(value.formatted())\(unit.formatted())"
        }
        
        private func convert(to unit: Unit) -> Double {
            let convertedValue = value * Self.conversionTable[self.unit]![unit]!
            return convertedValue.rounded(to: Self.precision)
        }
    }
}

extension Workout.Exercise.Duration: Equatable {
    static func == (lhs: Workout.Exercise.Duration, rhs: Workout.Exercise.Duration) -> Bool {
        lhs.value == rhs.convert(to: lhs.unit)
    }
}

extension Workout.Exercise.Duration: Codable { }
