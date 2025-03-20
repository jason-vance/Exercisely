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
            case .superset(let exercises, let sequenceLength):
                SupersetExercise(exercises, sequenceLength: sequenceLength)
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
    
    @ViewBuilder private func SupersetExercise(_ exercises: [Workout.Exercise], sequenceLength: Int) -> some View {
        NavigationLinkNoChevron {
            ExerciseGroupDetailView(for: exerciseGroup, in: workoutSection.id)
        } label: {
            VStack(spacing: 0) {
                ExerciseGroupName(exerciseGroup)
                ForEach(0..<sequenceLength, id: \.self) { i in
                    let exercises = Array(exercises.suffix(from: i)).every(nth: sequenceLength)
                    let set = ExerciseGroup.set(exercises)
                    VStack(spacing: 0) {
                        HStack {
                            Bullet().hidden()
                            ExerciseGroupName(set)
                        }
                        HStack {
                            Bullet().hidden()
                            Bullet().hidden()
                            let sets = exercises.count
                            if sets > 1 {
                                ExerciseSets(sets)
                            }
                            ExerciseRowCommonMetrics(exercises)
                        }
                    }
                }
            }
        }
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
                    ExerciseRowCommonMetrics(exercises)
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
                    ExerciseRowCommonMetrics(exercises)
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
}

#Preview {
    let single = ExerciseGroup.sampleSingle
    let simpleSet = ExerciseGroup.sampleSimpleSet
    let complexSet1 = ExerciseGroup.sampleVariableWeightAndRepSet
    let complexSet2 = ExerciseGroup.sampleVariableDistanceAndDurationSet
    let complexSetWithRest = ExerciseGroup.sampleFakeDropSetButItHasRests
    let dropSet = ExerciseGroup.sampleDropSet
    let superset = ExerciseGroup.sampleSuperset

    List {
        Section {
            WorkoutViewExerciseRow(simpleSet, in: .sampleWorkout)
            WorkoutViewExerciseRow(complexSet1, in: .sampleWorkout)
            WorkoutViewExerciseRow(complexSet2, in: .sampleWorkout)
            WorkoutViewExerciseRow(complexSetWithRest, in: .sampleWorkout)
            WorkoutViewExerciseRow(dropSet, in: .sampleWorkout)
            WorkoutViewExerciseRow(superset, in: .sampleWorkout)
            WorkoutViewExerciseRow(single, in: .sampleWorkout)
        } header: {
            SectionHeader("Workout")
        }
    }
    .listDefaultModifiers()
}
