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
    
    @Test func formatsCorrectly() {
        #expect(Weight(value: 10, unit: .kilograms).formatted() == "10kg")
        #expect(Weight(value: 12.5, unit: .kilograms).formatted() == "12.5kg")
        #expect(Weight(value: 10, unit: .pounds).formatted() == "10lbs")
        #expect(Weight(value: 17.5, unit: .pounds).formatted() == "17.5lbs")
    }
}
