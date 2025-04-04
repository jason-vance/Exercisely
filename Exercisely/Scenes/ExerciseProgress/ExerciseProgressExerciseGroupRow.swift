//
//  ExerciseProgressExerciseGroupRow.swift
//  Exercisely
//
//  Created by Jason Vance on 4/3/25.
//

import SwiftUI

struct ExerciseProgressExerciseGroupRow: View {
    
    private let exerciseGroup: ExerciseGroup
    
    init(_ exerciseGroup: ExerciseGroup) {
        self.exerciseGroup = exerciseGroup
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
        .animation(.snappy, value: exerciseGroup.exercises)
    }
    
    @ViewBuilder private func SupersetExercise(_ exercises: [Workout.Exercise], sequenceLength: Int) -> some View {
        VStack(spacing: 0) {
            if let date = exercises.first?.workoutSection?.workout?.date {
                HStack {
                    Text(date.formatted())
                        .exerciseDate()
                    Spacer()
                }
            }
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
    
    @ViewBuilder private func DropSetExercise(_ exercises: [Workout.Exercise]) -> some View {
        VStack(spacing: 0) {
            if let date = exercises.first?.workoutSection?.workout?.date {
                HStack {
                    Text(date.formatted())
                        .exerciseDate()
                    Spacer()
                }
            }
            ExerciseGroupName(exerciseGroup)
            HStack {
                Bullet().hidden()
                let drops = exercises.count - 1
                ExerciseDrops(drops)
                ExerciseRowCommonMetrics(exercises)
            }
        }
    }
    
    @ViewBuilder private func SetExercise(_ exercises: [Workout.Exercise]) -> some View {
        VStack(spacing: 0) {
            if let date = exercises.first?.workoutSection?.workout?.date {
                HStack {
                    Text(date.formatted())
                        .exerciseDate()
                    Spacer()
                }
            }
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
    
    @ViewBuilder private func ExerciseGroupName(_ exerciseGroup: ExerciseGroup) -> some View {
        HStack {
            Bullet()
            Text(exerciseGroup.nameFormatted)
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

fileprivate extension View {
    func exerciseDate() -> some View {
        self
            .font(.caption2)
            .bold()
            .foregroundColor(.text)
            .opacity(0.5)
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
            ExerciseProgressExerciseGroupRow(simpleSet)
            ExerciseProgressExerciseGroupRow(complexSet1)
            ExerciseProgressExerciseGroupRow(complexSet2)
            ExerciseProgressExerciseGroupRow(complexSetWithRest)
            ExerciseProgressExerciseGroupRow(dropSet)
            ExerciseProgressExerciseGroupRow(superset)
            ExerciseProgressExerciseGroupRow(single)
        } header: {
            Text("Previous")
                .librarySectionHeader()
        }
    }
    .listDefaultModifiers()
}
