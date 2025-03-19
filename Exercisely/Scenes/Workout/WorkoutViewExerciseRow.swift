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
            case .set(let exercises):
                SetExercise(exercises)
            case .dropSet(let exercises):
                DropSetExercise(exercises)
            case .superset(let exercises):
                SupersetExercise(exercises)
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
    
    @ViewBuilder private func SupersetExercise(_ exercises: [Workout.Exercise]) -> some View {
        //TODO: Fill SupersetExercise out
        Text("Some Superset")
    }
    
    @ViewBuilder private func DropSetExercise(_ exercises: [Workout.Exercise]) -> some View {
        NavigationLinkNoChevron {
            ExerciseGroupDetailView(for: exerciseGroup, in: workoutSection.id)
        } label: {
            VStack(spacing: 0) {
                ExerciseGroupName(exerciseGroup)
                HStack {
                    Bullet().hidden()
                    let drops = exercises.count - 1
                    ExerciseDrops(drops)
                    CommonMetrics(exercises)
                }
            }
        }
    }
    
    @ViewBuilder private func SetExercise(_ exercises: [Workout.Exercise]) -> some View {
        NavigationLinkNoChevron {
            ExerciseGroupDetailView(for: exerciseGroup, in: workoutSection.id)
        } label: {
            VStack(spacing: 0) {
                ExerciseGroupName(exerciseGroup)
                HStack {
                    Bullet().hidden()
                    let sets = exercises.count
                    if sets > 1 {
                        ExerciseSets(sets)
                    }
                    CommonMetrics(exercises)
                }
            }
        }
    }
    
    @ViewBuilder private func ExerciseGroupName(_ exerciseGroup: ExerciseGroup) -> some View {
        HStack {
            Bullet()
            Text(exerciseGroup.name)
                .multilineTextAlignment(.leading)
            Spacer(minLength: 0)
        }
        .font(.headline)
    }
    
    @ViewBuilder private func ExerciseDrops(_ drops: Int) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "arrow.down.to.line.compact")
            Text("\(drops)drops")
                .contentTransition(.numericText())
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func ExerciseSets(_ sets: Int) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "square.stack.3d.up")
            Text("\(sets)sets")
                .contentTransition(.numericText())
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func CommonMetrics(_ exercises: [Workout.Exercise]) -> some View {
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
    let single = ExerciseGroup.sampleSingle
    let simpleSet = ExerciseGroup.sampleSimpleSet
    let complexSet1 = ExerciseGroup.sampleVariableWeightAndRepSet
    let complexSet2 = ExerciseGroup.sampleVariableDistanceAndDurationSet
    let complexSetWithRest = ExerciseGroup.sampleFakeDropSetButItHasRests
    let dropSet = ExerciseGroup.sampleDropSet

    List {
        Section {
            WorkoutViewExerciseRow(single, in: .sampleWorkout)
            WorkoutViewExerciseRow(simpleSet, in: .sampleWorkout)
            WorkoutViewExerciseRow(complexSet1, in: .sampleWorkout)
            WorkoutViewExerciseRow(complexSet2, in: .sampleWorkout)
            WorkoutViewExerciseRow(complexSetWithRest, in: .sampleWorkout)
            WorkoutViewExerciseRow(dropSet, in: .sampleWorkout)
        } header: {
            SectionHeader("Workout")
        }
    }
    .listDefaultModifiers()
}
