//
//  ExerciseDuration.swift
//  Exercisely
//
//  Created by Jason Vance on 3/12/25.
//

import Foundation

extension Workout.Exercise {
    struct Duration {
        
        enum FormatOptions {
            case regular
            case rest
        }
        
        private static let secsPerMin: Double = 60
        private static let minsPerHour: Double = 60
        private static let precision: Int = 3
        
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
            guard value > 0 else { return nil }
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
        
        func subtracting(_ other: Duration) -> Duration? {
            guard let converted = other.convert(to: self.unit) else {
                return self
            }
            return subtracting(converted.value)
        }
        
        func subtracting(_ value: Double) -> Duration? {
            .init(value: self.value - value, unit: self.unit)
        }
        
        func adding(_ other: Duration) -> Duration {
            guard let converted = other.convert(to: self.unit) else {
                return self
            }
            return adding(converted.value)
        }
        
        func adding(_ value: Double) -> Duration {
            return .init(value: self.value + value, unit: self.unit)!
        }
        
        func formatted() -> String {
            "\(value.formatted())\(unit.formatted())"
        }
        
        static func formatted(_ durations: [Duration?], options: FormatOptions = .regular) -> String {
            guard !durations.compactMap(\.self).isEmpty else { return "??s" }
            guard durations.count > 1 else { return durations[0]?.formatted() ?? "???" }
            
            var durations = durations
            if options == .rest {
                var last = durations.last!
                while last == nil {
                    durations.removeLast()
                    last = durations.last!
                }
            }
            
            let allAreSameValue = Set(durations.map({ $0?.value })).count == 1
            let allAreSameUnit = Set(durations.compactMap({ $0?.unit })).count == 1
            if allAreSameValue && allAreSameUnit {
                return durations[0]?.formatted() ?? "????"
            } else {
                if allAreSameUnit {
                    let valuesString = durations.map({ "\($0 == nil ? "-" : "\($0!.value.formatted())")" }).joined(separator: ",")
                    return "\(valuesString)\(durations.compactMap(\.self)[0]?.unit.formatted() ?? "??")"
                } else {
                    return durations.map({ $0?.formatted() ?? "-" }).joined(separator: ",")
                }
            }
        }
        
        private func convert(to unit: Unit) -> Duration? {
            let convertedValue = value * Self.conversionTable[self.unit]![unit]!
            return .init(value: convertedValue.rounded(to: Self.precision), unit: unit)
        }
    }
}

extension Workout.Exercise.Duration: Comparable {
    public static func < (lhs: Workout.Exercise.Duration, rhs: Workout.Exercise.Duration) -> Bool {
        guard let converted = rhs.convert(to: lhs.unit) else {
            return false
        }
        return lhs.value < converted.value
    }
}

extension Workout.Exercise.Duration: Equatable {
    static func == (lhs: Workout.Exercise.Duration, rhs: Workout.Exercise.Duration) -> Bool {
        guard let converted = rhs.convert(to: lhs.unit) else {
            return false
        }
        return lhs.value == converted.value
    }
}

extension Workout.Exercise.Duration: Codable { }
