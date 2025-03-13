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
    
    private let value: Double
    private let unit: Unit
    
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
    
    func formatted() -> String {
        "\(value.formatted())\(unit.formatted())"
    }
    
    private func convert(to unit: Unit) -> Double {
        var convertedValue: Double = 0
        
        switch unit {
        case .pounds:
            convertedValue = self.unit == .pounds ? value : value * Self.lbsPerKg
        case .kilograms:
            convertedValue = self.unit == .kilograms ? value : value / Self.lbsPerKg
        }
        
        return convertedValue.rounded(to: Self.precision)
    }
}

extension Weight: Equatable {
    static func == (lhs: Weight, rhs: Weight) -> Bool {
        lhs.value == rhs.convert(to: lhs.unit)
    }
}

extension Weight: Codable { }
