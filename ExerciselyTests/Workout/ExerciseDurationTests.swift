//
//  ExerciseDurationTests.swift
//  ExerciselyTests
//
//  Created by Jason Vance on 3/12/25.
//

import Testing

struct ExerciseDurationTests {
    
    @Test func equivalentDurationsAreEqual() async throws {
        #expect(Workout.Exercise.Duration(value: 1, unit: .seconds) == Workout.Exercise.Duration(value: 1, unit: .seconds))
        #expect(Workout.Exercise.Duration(value: 1, unit: .seconds) == Workout.Exercise.Duration(value: 0.01666666667, unit: .minutes))
        #expect(Workout.Exercise.Duration(value: 1, unit: .seconds) == Workout.Exercise.Duration(value: 0.0002777777778, unit: .hours))
        
        #expect(Workout.Exercise.Duration(value: 1, unit: .minutes) == Workout.Exercise.Duration(value: 60, unit: .seconds))
        #expect(Workout.Exercise.Duration(value: 1, unit: .minutes) == Workout.Exercise.Duration(value: 1, unit: .minutes))
        #expect(Workout.Exercise.Duration(value: 1, unit: .minutes) == Workout.Exercise.Duration(value: 0.01666666667, unit: .hours))
        
        #expect(Workout.Exercise.Duration(value: 1, unit: .hours) == Workout.Exercise.Duration(value: 3600, unit: .seconds))
        #expect(Workout.Exercise.Duration(value: 1, unit: .hours) == Workout.Exercise.Duration(value: 60, unit: .minutes))
        #expect(Workout.Exercise.Duration(value: 1, unit: .hours) == Workout.Exercise.Duration(value: 1, unit: .hours))
    }

    @Test func nonEquivalentDurationsAreNotEqual() async throws {
        #expect(Workout.Exercise.Duration(value: 1, unit: .seconds) != Workout.Exercise.Duration(value: 2, unit: .seconds))
        #expect(Workout.Exercise.Duration(value: 1, unit: .seconds) != Workout.Exercise.Duration(value: 2, unit: .minutes))
        #expect(Workout.Exercise.Duration(value: 1, unit: .seconds) != Workout.Exercise.Duration(value: 2, unit: .hours))
        
        #expect(Workout.Exercise.Duration(value: 1, unit: .minutes) != Workout.Exercise.Duration(value: 2, unit: .seconds))
        #expect(Workout.Exercise.Duration(value: 1, unit: .minutes) != Workout.Exercise.Duration(value: 2, unit: .minutes))
        #expect(Workout.Exercise.Duration(value: 1, unit: .minutes) != Workout.Exercise.Duration(value: 2, unit: .hours))
        
        #expect(Workout.Exercise.Duration(value: 1, unit: .hours) != Workout.Exercise.Duration(value: 2, unit: .seconds))
        #expect(Workout.Exercise.Duration(value: 1, unit: .hours) != Workout.Exercise.Duration(value: 2, unit: .minutes))
        #expect(Workout.Exercise.Duration(value: 1, unit: .hours) != Workout.Exercise.Duration(value: 2, unit: .hours))
    }
    
    @Test func formatsCorrectly() {
        #expect(Workout.Exercise.Duration(value: 10, unit: .minutes)!.formatted() == "10m")
        #expect(Workout.Exercise.Duration(value: 1.5, unit: .hours)!.formatted() == "1.5h")
        #expect(Workout.Exercise.Duration(value: 30, unit: .seconds)!.formatted() == "30s")
    }
    
    @Test
    func classFormattedFormatsCorrectly() async throws {
        var x = Workout.Exercise.Duration.formatted([
            .init(value: 10, unit: .seconds),
            .init(value: 10, unit: .seconds),
            .init(value: 10, unit: .seconds),
        ])
        #expect(x == "10s")
        
        x = Workout.Exercise.Duration.formatted([
            .init(value: 10, unit: .minutes),
            .init(value: 12, unit: .minutes),
            .init(value: 15, unit: .minutes),
        ])
        #expect(x == "10,12,15m")
        
        x = Workout.Exercise.Duration.formatted([
            .init(value: 10, unit: .hours),
            nil,
            .init(value: 15, unit: .hours),
        ])
        #expect(x == "10,-,15h")
        
        x = Workout.Exercise.Duration.formatted([
            .init(value: 10, unit: .seconds),
            nil,
            .init(value: 10, unit: .seconds),
        ])
        #expect(x == "10,-,10s")
        
        x = Workout.Exercise.Duration.formatted([
            nil,
            nil,
            nil,
        ])
        #expect(x == "??s")
        
        x = Workout.Exercise.Duration.formatted([
            .init(value: 10, unit: .hours),
            .init(value: 10, unit: .minutes),
        ])
        #expect(x == "10h,10m")
        
        x = Workout.Exercise.Duration.formatted([
            .init(value: 10, unit: .minutes),
            nil,
            .init(value: 10, unit: .seconds),
        ])
        #expect(x == "10m,-,10s")
    }
}
