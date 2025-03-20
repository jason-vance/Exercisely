//
//  ExerciseRowCommonMetrics.swift
//  Exercisely
//
//  Created by Jason Vance on 3/19/25.
//

import SwiftUI

struct ExerciseRowCommonMetrics: View {
    
    let exercises: [Workout.Exercise]
    
    init(_ exercises: [Workout.Exercise]) {
        self.exercises = exercises
    }
    
    var body: some View {
        HStack {
            if !exercises.compactMap(\.reps).isEmpty {
                ExerciseReps(exercises.map(\.reps))
            }
            if !exercises.compactMap(\.weight).isEmpty {
                ExerciseWeight(exercises.map(\.weight))
            }
            if !exercises.compactMap(\.distance).isEmpty {
                ExerciseDistance(exercises.map(\.distance))
            }
            if !exercises.compactMap(\.duration).isEmpty {
                ExerciseDuration(exercises.map(\.duration))
            }
            if !exercises.compactMap(\.rest).isEmpty {
                ExerciseRest(exercises.map(\.rest))
            }
            Spacer(minLength: 0)
        }
    }
    
    @ViewBuilder private func ExerciseReps(_ reps: [Workout.Exercise.Reps?]) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "arrow.triangle.2.circlepath")
            Text("\(Workout.Exercise.Reps.formatted(reps))")
                .contentTransition(.numericText())
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func ExerciseWeight(_ weights: [Weight?]) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "dumbbell")
            Text("\(Weight.formatted(weights))")
                .contentTransition(.numericText())
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func ExerciseDistance(_ distances: [Distance?]) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "point.bottomleft.forward.to.arrow.triangle.scurvepath")
            Text("\(Distance.formatted(distances))")
                .contentTransition(.numericText())
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func ExerciseDuration(_ durations: [Workout.Exercise.Duration?]) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "timer")
            Text("\(Workout.Exercise.Duration.formatted(durations))")
                .contentTransition(.numericText())
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func ExerciseRest(_ durations: [Workout.Exercise.Duration?]) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "hourglass")
            Text("\(Workout.Exercise.Duration.formatted(durations, options: .rest)) rest")
                .contentTransition(.numericText())
        }
        .workoutExerciseDataItem()
    }
}

#Preview {
    ExerciseRowCommonMetrics(ExerciseGroup.sampleSimpleSet.exercises)
}
