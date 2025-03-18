//
//  ExerciseRepsTests.swift
//  ExerciselyTests
//
//  Created by Jason Vance on 3/12/25.
//

import Testing

struct ExerciseRepsTests {

    @Test
    func onlyPositiveValues() async throws {
        #expect(Workout.Exercise.Reps(-1) == nil)
        #expect(Workout.Exercise.Reps(0) == nil)
        #expect(Workout.Exercise.Reps(1) != nil)
    }
    
    @Test
    func instanceFormattedFormatsCorrectly() async throws {
        #expect(Workout.Exercise.Reps(12)!.formatted() == "12reps")
    }
    
    @Test
    func classFormattedFormatsCorrectly() async throws {
        var x = Workout.Exercise.Reps.formatted([
            .init(10),
            .init(10),
            .init(10),
        ])
        #expect(x == "10reps")
        
        x = Workout.Exercise.Reps.formatted([
            .init(10),
            .init(12),
            .init(15),
        ])
        #expect(x == "10,12,15reps")
        
        x = Workout.Exercise.Reps.formatted([
            .init(10),
            nil,
            .init(15),
        ])
        #expect(x == "10,-,15reps")
        
        x = Workout.Exercise.Reps.formatted([
            .init(10),
            nil,
            .init(10),
        ])
        #expect(x == "10,-,10reps")
        
        x = Workout.Exercise.Reps.formatted([
            nil,
            .init(10),
        ])
        #expect(x == "-,10reps")
        
        x = Workout.Exercise.Reps.formatted([
            nil,
            nil,
            nil,
        ])
        #expect(x == "??reps")
    }
}
