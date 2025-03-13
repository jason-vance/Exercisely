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
    private static let precision: Int = 4
    
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
    
    private let value: Double
    private let unit: Unit
    
    init(value: Double, unit: Unit) {
        self.value = value
        self.unit = unit
    }
    
    static func feet(_ value: Double) -> Self {
        .init(value: value, unit: .feet)
    }
    
    static func miles(_ value: Double) -> Self {
        .init(value: value, unit: .miles)
    }
    
    static func meters(_ value: Double) -> Self {
        .init(value: value, unit: .meters)
    }
    
    static func kilometers(_ value: Double) -> Self {
        .init(value: value, unit: .kilometers)
    }
    
    func formatted() -> String {
        "\(value.formatted())\(unit.formatted())"
    }
    
    private func convert(to unit: Unit) -> Double {
        let convertedValue = value * Self.conversionTable[self.unit]![unit]!
        return convertedValue.rounded(to: Self.precision)
    }
}

extension Distance: Equatable {
    static func == (lhs: Distance, rhs: Distance) -> Bool {
        lhs.value == rhs.convert(to: lhs.unit)
    }
}

extension Distance: Codable { }
