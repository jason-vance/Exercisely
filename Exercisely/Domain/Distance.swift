//
//  Distance.swift
//  Exercisely
//
//  Created by Jason Vance on 3/12/25.
//

import Foundation

struct Distance {
    
    private static let feetPerMeter: Double = 3.28084
    private static let feetPerMile: Double = 5280
    private static let metersPerKm: Double = 1000
    private static let precision: Int = 3
    
    private static let conversionTable: Dictionary<Unit, Dictionary<Unit, Double>> = [
        .feet: [
            .feet: 1,
            .miles: 1 / Distance.feetPerMile,
            .meters: 1 / Distance.feetPerMeter,
            .kilometers: 1 / Distance.feetPerMeter / Distance.metersPerKm
            ],
        .miles: [
            .feet: Distance.feetPerMile,
            .miles: 1,
            .meters: Distance.feetPerMile / Distance.feetPerMeter,
            .kilometers: Distance.feetPerMile / Distance.feetPerMeter / Distance.metersPerKm
            ],
        .meters: [
            .feet: Distance.feetPerMeter,
            .miles: Distance.feetPerMeter / Distance.feetPerMile,
            .meters: 1,
            .kilometers: 1 / Distance.metersPerKm
            ],
        .kilometers: [
            .feet: Distance.metersPerKm * Distance.feetPerMeter,
            .miles: Distance.metersPerKm * Distance.feetPerMeter / Distance.feetPerMile,
            .meters: Distance.metersPerKm,
            .kilometers: 1
        ]
    ]
    
    enum Unit: Codable {
        case feet
        case miles
        case meters
        case kilometers

        func formatted() -> String {
            switch self {
            case .feet:
                return "ft"
            case .miles:
                return "mi"
            case .meters:
                return "m"
            case .kilometers:
                return "km"
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
    
    static func feet(_ value: Double) -> Self? {
        .init(value: value, unit: .feet)
    }
    
    static func miles(_ value: Double) -> Self? {
        .init(value: value, unit: .miles)
    }
    
    static func meters(_ value: Double) -> Self? {
        .init(value: value, unit: .meters)
    }
    
    static func kilometers(_ value: Double) -> Self? {
        .init(value: value, unit: .kilometers)
    }
    
    func subtracting(_ other: Distance) -> Distance? {
        guard let converted = other.convert(to: self.unit) else {
            return self
        }
        return subtracting(converted.value)
    }
    
    func subtracting(_ value: Double) -> Distance? {
        .init(value: self.value - value, unit: self.unit)
    }
    
    func adding(_ other: Distance) -> Distance {
        guard let converted = other.convert(to: self.unit) else {
            return self
        }
        return adding(converted.value)
    }
    
    func adding(_ value: Double) -> Distance {
        return .init(value: self.value + value, unit: self.unit)!
    }
    
    func formatted() -> String {
        "\(value.formatted())\(unit.formatted())"
    }
    
    static func formatted(_ distances: [Distance?]) -> String {
        guard !distances.compactMap(\.self).isEmpty else { return "??mi" }
        guard distances.count > 1 else { return distances[0]?.formatted() ?? "???" }
        
        let allAreSameValue = Set(distances.map({ $0?.value })).count == 1
        let allAreSameUnit = Set(distances.compactMap({ $0?.unit })).count == 1
        if allAreSameValue && allAreSameUnit {
            return distances[0]?.formatted() ?? "????"
        } else {
            if allAreSameUnit {
                let valuesString = distances.map({ "\($0 == nil ? "-" : "\($0!.value.formatted())")" }).joined(separator: ",")
                return "\(valuesString)\(distances.compactMap(\.self)[0]?.unit.formatted() ?? "??")"
            } else {
                return distances.map({ $0?.formatted() ?? "-" }).joined(separator: ",")
            }
        }
    }
    
    private func convert(to unit: Unit) -> Distance? {
        let convertedValue = value * Self.conversionTable[self.unit]![unit]!
        return .init(value: convertedValue.rounded(to: Self.precision), unit: unit)
    }
}

extension Distance: Equatable {
    static func == (lhs: Distance, rhs: Distance) -> Bool {
        guard let converted = rhs.convert(to: lhs.unit) else {
            return false
        }
        return lhs.value == converted.value
    }
}

extension Distance: Codable { }
