//
//  Weight.swift
//  Exercisely
//
//  Created by Jason Vance on 3/12/25.
//

import Foundation

struct Weight {
    
    private static let lbsPerKg: Double = 2.20462
    private static let precision: Int = 3
    
    enum Unit: Codable {
        case pounds
        case kilograms
        
        func formatted() -> String {
            switch self {
            case .pounds: return "lbs"
            case .kilograms: return "kg"
            }
        }
    }
    
    let value: Double
    let unit: Unit
    
    init(value: Double, unit: Unit) {
        self.value = value
        self.unit = unit
    }
    
    static func pounds(_ value: Double) -> Self {
        .init(value: value, unit: .pounds)
    }
    
    static func kilograms(_ value: Double) -> Self {
        .init(value: value, unit: .kilograms)
    }
    
    func subtracting(_ other: Weight) -> Weight {
        let converted = other.convert(to: self.unit)
        return subtracting(converted.value)
    }
    
    func subtracting(_ value: Double) -> Weight {
        return .init(value: self.value - value, unit: self.unit)
    }
    
    func adding(_ other: Weight) -> Weight {
        return adding(other.convert(to: self.unit).value)
    }
    
    func adding(_ value: Double) -> Weight {
        return .init(value: self.value + value, unit: self.unit)
    }
    
    func formatted() -> String {
        "\(value.formatted())\(unit.formatted())"
    }
    
    static func formatted(_ weights: [Weight?]) -> String {
        guard !weights.compactMap(\.self).isEmpty else { return "??lbs" }
        guard weights.count > 1 else { return weights[0]?.formatted() ?? "???" }
        
        let allAreSameValue = Set(weights.map({ $0?.value })).count == 1
        let allAreSameUnit = Set(weights.compactMap({ $0?.unit })).count == 1
        if allAreSameValue && allAreSameUnit {
            return weights[0]?.formatted() ?? "????"
        } else {
            if allAreSameUnit {
                let valuesString = weights.map({ "\($0 == nil ? "-" : "\($0!.value.formatted())")" }).joined(separator: ",")
                return "\(valuesString)\(weights.compactMap(\.self)[0]?.unit.formatted() ?? "??")"
            } else {
                return weights.map({ $0?.formatted() ?? "-" }).joined(separator: ",")
            }
        }
    }
    
    func convert(to unit: Unit) -> Weight {
        var convertedValue: Double = 0
        
        switch unit {
        case .pounds:
            convertedValue = self.unit == .pounds ? value : value * Self.lbsPerKg
        case .kilograms:
            convertedValue = self.unit == .kilograms ? value : value / Self.lbsPerKg
        }
        
        return Weight(value: convertedValue.rounded(to: Self.precision), unit: unit)
    }
}

extension Weight: Comparable {
    public static func < (lhs: Weight, rhs: Weight) -> Bool {
        lhs.value < rhs.convert(to: lhs.unit).value
    }
}

extension Weight: Equatable {
    static func == (lhs: Weight, rhs: Weight) -> Bool {
        lhs.value == rhs.convert(to: lhs.unit).value
    }
}

extension Weight: Codable { }
