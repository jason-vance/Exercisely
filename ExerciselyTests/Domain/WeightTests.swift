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
        
        x = Weight.formatted([
            nil,
            .init(value: 10, unit: .kilograms),
        ])
        #expect(x == "-,10kg")
    }
    
    @Test
    func subtractingSameUnits() {
        let fivePounds = Weight(value: 5, unit: .pounds)
        let twoPounds = fivePounds.subtracting(3)
        #expect(twoPounds.value == 2)
        #expect(twoPounds.unit == .pounds)

        let threePounds = fivePounds.subtracting(twoPounds)
        #expect(threePounds.value == 3)
        #expect(threePounds.unit == .pounds)
    }
    
    @Test
    func subtractingDifferentUnits() {
        let fivePounds = Weight(value: 5, unit: .pounds)
        let fiveKg = Weight(value: 5, unit: .kilograms)

        let towAndSomeKg = fiveKg.subtracting(fivePounds)
        #expect(towAndSomeKg.value == 2.732)
        #expect(towAndSomeKg.unit == .kilograms)
    }
    
    @Test
    func addingSameUnits() {
        let fivePounds = Weight(value: 5, unit: .pounds)
        let eightPounds = fivePounds.adding(3)
        #expect(eightPounds.value == 8)
        #expect(eightPounds.unit == .pounds)

        let thirteenPounds = fivePounds.adding(eightPounds)
        #expect(thirteenPounds.value == 13)
        #expect(thirteenPounds.unit == .pounds)
    }
    
    @Test
    func addingDifferentUnits() {
        let fivePounds = Weight(value: 5, unit: .pounds)
        let fiveKg = Weight(value: 5, unit: .kilograms)

        let sevenAndSomeKg = fiveKg.adding(fivePounds)
        #expect(sevenAndSomeKg.value == 7.268)
        #expect(sevenAndSomeKg.unit == .kilograms)
    }
    
    @Test
    func comparingSameUnits() {
        let fivePounds = Weight(value: 5, unit: .pounds)
        let eightPounds = Weight(value: 8, unit: .pounds)
        #expect(fivePounds < eightPounds)
        #expect(eightPounds > fivePounds)
    }
    
    @Test
    func comparingDifferentUnits() {
        let fivePounds = Weight(value: 5, unit: .pounds)
        let fiveKg = Weight(value: 5, unit: .kilograms)
        #expect(fivePounds < fiveKg)
        #expect(fiveKg > fivePounds)
    }
}
