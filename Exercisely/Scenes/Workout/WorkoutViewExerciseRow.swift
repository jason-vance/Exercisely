//
//  WorkoutViewExerciseRow.swift
//  Exercisely
//
//  Created by Jason Vance on 3/15/25.
//

import SwiftUI

struct WorkoutViewExerciseRow: View {
    
    @State var exercise: ExerciseGroup
    
    var body: some View {
        VStack {
            switch exercise {
            case .single(let exercise):
                SingleExercise(exercise)
            case .set(let exercises):
                SetExercise(exercises)
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func SingleExercise(_ exercise: Workout.Exercise) -> some View {
        SetExercise([exercise])
    }
    
    @ViewBuilder private func SetExercise(_ exercises: [Workout.Exercise]) -> some View {
        if let exercise = exercises.first {
            VStack(spacing: 0) {
                HStack {
                    Bullet()
                    Text(exercise.name.formatted())
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 0)
                }
                .font(.headline)
                HStack {
                    Bullet().hidden()
                    let sets = exercises.count
                    if sets > 1 {
                        ExerciseSets(sets)
                    }
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
                    Spacer(minLength: 0)
                }
            }
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder func Bullet() -> some View {
        Image(systemName: "circle.fill")
            .resizable()
            .frame(width: .activityRowBulletSize, height: .activityRowBulletSize)
    }
    
    @ViewBuilder private func ExerciseSets(_ sets: Int) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "square.stack.3d.up")
            Text("\(sets)sets")
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func ExerciseReps(_ reps: [Workout.Exercise.Reps?]) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "arrow.triangle.2.circlepath")
            Text("\(Workout.Exercise.Reps.formatted(reps))")
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func ExerciseWeight(_ weights: [Weight?]) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "dumbbell")
            Text("\(Weight.formatted(weights))")
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func ExerciseDistance(_ distances: [Distance?]) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "point.bottomleft.forward.to.arrow.triangle.scurvepath")
            Text("\(Distance.formatted(distances))")
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func ExerciseDuration(_ durations: [Workout.Exercise.Duration?]) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "timer")
            Text("\(Workout.Exercise.Duration.formatted(durations))")
        }
        .workoutExerciseDataItem()
    }
}

#Preview {
    let single = ExerciseGroup.sampleSingle
    let simpleSet = ExerciseGroup.sampleSimpleSet
    let complexSet1 = ExerciseGroup.sampleVariableWeightAndRepSet
    let complexSet2 = ExerciseGroup.sampleVariableDistanceAndDurationSet

    List {
        Section {
            WorkoutViewExerciseRow(exercise: single)
            WorkoutViewExerciseRow(exercise: simpleSet)
            WorkoutViewExerciseRow(exercise: complexSet1)
            WorkoutViewExerciseRow(exercise: complexSet2)
        } header: {
            SectionHeader("Workout")
        }
    }
    .listDefaultModifiers()
}
