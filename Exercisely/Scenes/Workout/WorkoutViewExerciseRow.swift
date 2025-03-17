//
//  WorkoutViewExerciseRow.swift
//  Exercisely
//
//  Created by Jason Vance on 3/15/25.
//

import SwiftUI

struct WorkoutViewExerciseRow: View {
    
    private let workoutSection: Workout.Section
    private let exerciseGroup: ExerciseGroup
    
    @State private var showExerciseOptions: Bool = false {
        didSet {
            if showExerciseOptions {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showExerciseOptions = false
                }
            }
        }
    }
    
    @State private var showDeleteConfirmation: Bool = false
    
    init(_ exerciseGroup: ExerciseGroup, in section: Workout.Section) {
        self.workoutSection = section
        self.exerciseGroup = exerciseGroup
    }
    
    private func deleteExercise() {
        withAnimation(.snappy) {
            for exercise in exerciseGroup.exercises {
                workoutSection.remove(exercise: exercise)
            }
        }
    }
    
    var body: some View {
        VStack {
            switch exerciseGroup {
            case .single(let exercise):
                SingleExercise(exercise)
            case .set(let exercises):
                SetExercise(exercises)
            }
        }
        .workoutExerciseRow()
        .animation(.snappy, value: showExerciseOptions)
        .animation(.snappy, value: exerciseGroup.exercises)
        .confirmationDialog(
            "Are you sure you want to remove the \"\(exerciseGroup.name)\" exercise?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete It!", role: .destructive, action: deleteExercise)
            Button("Cancel", role: .cancel) { }
        }
    }
    
    @ViewBuilder private func SingleExercise(_ exercise: Workout.Exercise) -> some View {
        SetExercise([exercise])
    }
    
    @ViewBuilder private func SetExercise(_ exercises: [Workout.Exercise]) -> some View {
        NavigationLinkNoChevron {
            ExerciseGroupDetailView(for: exerciseGroup, in: workoutSection.id)
        } label: {
            VStack(spacing: 0) {
                HStack {
                    Bullet()
                    Text(exerciseGroup.name)
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
        }
    }
    
    @ViewBuilder private func ExerciseSets(_ sets: Int) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "square.stack.3d.up")
            Text("\(sets)sets")
                .contentTransition(.numericText())
        }
        .workoutExerciseDataItem()
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
}

#Preview {
    let single = ExerciseGroup.sampleSingle
    let simpleSet = ExerciseGroup.sampleSimpleSet
    let complexSet1 = ExerciseGroup.sampleVariableWeightAndRepSet
    let complexSet2 = ExerciseGroup.sampleVariableDistanceAndDurationSet

    List {
        Section {
            WorkoutViewExerciseRow(single, in: .sampleWorkout)
            WorkoutViewExerciseRow(simpleSet, in: .sampleWorkout)
            WorkoutViewExerciseRow(complexSet1, in: .sampleWorkout)
            WorkoutViewExerciseRow(complexSet2, in: .sampleWorkout)
        } header: {
            SectionHeader("Workout")
        }
    }
    .listDefaultModifiers()
}
