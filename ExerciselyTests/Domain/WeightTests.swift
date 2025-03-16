//
//  WeightTests.swift
//  ExerciselyTests
//
//  Created by Jason Vance on 3/12/25.
//

import Testing

struct WeightTests {

    @Test func equivalentWeightsAreEqual() async throws {
        #expect(Weight(value: 1, unit: .kilograms) == Weight(value: 1, unit: .kilograms))
        #expect(Weight(value: 1, unit: .pounds) == Weight(value: 1, unit: .pounds))
        #expect(Weight(value: 1, unit: .pounds) == Weight(value: 0.453592, unit: .kilograms))
        #expect(Weight(value: 1, unit: .kilograms) == Weight(value: 2.20462, unit: .pounds))
    }

    @Test func nonEquivalentWeightsAreNotEqual() async throws {
        #expect(Weight(value: 1, unit: .kilograms) != Weight(value: 2, unit: .kilograms))
        #expect(Weight(value: 1, unit: .pounds) != Weight(value: 2, unit: .pounds))
        #expect(Weight(value: 1, unit: .kilograms) != Weight(value: 1, unit: .pounds))
        #expect(Weight(value: 1, unit: .pounds) != Weight(value: 1, unit: .kilograms))
    }
    
    @Test func instanceFormattedFormatsCorrectly() {
        #expect(Weight(value: 10, unit: .kilograms).formatted() == "10kg")
        #expect(Weight(value: 12.5, unit: .kilograms).formatted() == "12.5kg")
        #expect(Weight(value: 10, unit: .pounds).formatted() == "10lbs")
        #expect(Weight(value: 17.5, unit: .pounds).formatted() == "17.5lbs")
    }
    
    @Test
    func classFormattedFormatsCorrectly() async throws {
        var x = Weight.formatted([
            .init(value: 10, unit: .pounds),
            .init(value: 10, unit: .pounds),
            .init(value: 10, unit: .pounds),
        ])
        #expect(x == "10lbs")
        
        x = Weight.formatted([
            .init(value: 10, unit: .pounds),
            .init(value: 12, unit: .pounds),
            .init(value: 15, unit: .pounds),
        ])
        #expect(x == "10,12,15lbs")
        
        x = Weight.formatted([
            .init(value: 10, unit: .pounds),
            nil,
            .init(value: 15, unit: .pounds),
        ])
        #expect(x == "10,-,15lbs")
        
        x = Weight.formatted([
            .init(value: 10, unit: .pounds),
            nil,
            .init(value: 10, unit: .pounds),
        ])
        #expect(x == "10,-,10lbs")
        
        x = Weight.formatted([
            nil,
            nil,
            nil,
        ])
        #expect(x == "??lbs")
        
        x = Weight.formatted([
            .init(value: 10, unit: .pounds),
            .init(value: 10, unit: .kilograms),
        ])
        #expect(x == "10lbs,10kg")
        
        x = Weight.formatted([
            .init(value: 10, unit: .pounds),
            nil,
            .init(value: 10, unit: .kilograms),
        ])
        #expect(x == "10lbs,-,10kg")
    }
}
