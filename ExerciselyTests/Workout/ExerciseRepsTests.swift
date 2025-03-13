//
//  ExerciseRepsTests.swift
//  ExerciselyTests
//
//  Created by Jason Vance on 3/12/25.
//

import Testing

struct ExerciseRepsTests {

    @Test func onlyPositiveValues() async throws {
        #expect(Workout.Exercise.Reps(-1) == nil)
        #expect(Workout.Exercise.Reps(0) == nil)
        #expect(Workout.Exercise.Reps(1) != nil)
    }

}
