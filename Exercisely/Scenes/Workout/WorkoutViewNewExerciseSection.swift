//
//  WorkoutViewNewExerciseSection.swift
//  Exercisely
//
//  Created by Jason Vance on 3/16/25.
//

import SwiftUI

struct WorkoutViewNewExerciseSection: View {
    
    let workoutSection: Workout.Section

    @State private var name: Workout.Exercise.Name? = nil
    @State private var weight: Weight? = nil
    @State private var reps: Workout.Exercise.Reps? = nil
    @State private var distance: Distance? = nil
    @State private var duration: Workout.Exercise.Duration? = nil
    
    
    private var exerciseToSave: Workout.Exercise? {
        guard let name = name else {
            return nil
        }
        
        let exercise = Workout.Exercise(
            name: name,
            weight: weight,
            reps: reps,
            distance: distance,
            duration: duration
        )
        
        guard let exercise = exercise else {
            return nil
        }
        
        return exercise
    }
    
    private var canSaveExercise: Bool { exerciseToSave != nil }
    private var hasName: Bool { name != nil }
    private var hasMetrics: Bool { reps != nil || distance != nil || duration != nil }

    private func saveExercise() {
        guard let exercise = exerciseToSave else {
            print("Failed to create Exercise to save")
            return
        }
        
        withAnimation(.snappy) {
            workoutSection.append(exercise: exercise)
        }
    }
    
    var body: some View {
        Section {
            NameField()
            WeightField()
            RepsField()
            DistanceField()
            DurationField()
            AddExerciseButton()
        } header: {
            HStack {
                Text("New Exercise")
                Spacer()
            }
                .font(.subheadline)
                .bold()
                .workoutExerciseRow()
                .underlined(Color.text.opacity(0.5))
        }
        .foregroundStyle(Color.text)
    }
    
    @ViewBuilder private func NameField() -> some View {
        NavigationLinkNoChevron {
            ExerciseNameEditView(name: $name)
        } label: {
            HStack {
                Text("Name")
                    .fieldLabel()
                Spacer(minLength: 0)
                Text(name?.formatted() ?? Workout.Exercise.Name.prompt.formatted())
                    .opacity(name == nil ? 0.35 : 1)
                    .fieldButton()
                    .underlined(canSaveExercise || hasName ? Color.accentColor : Color.red)
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func WeightField() -> some View {
        NavigationLinkNoChevron {
            ExerciseWeightEditView(weight: $weight)
        } label: {
            HStack {
                Text("Weight")
                    .fieldLabel()
                Spacer(minLength: 0)
                Text(weight?.formatted() ?? "N/A")
                    .fieldButton()
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func RepsField() -> some View {
        NavigationLinkNoChevron {
            ExerciseRepsEditView(reps: $reps)
        } label: {
            HStack {
                Text("Reps")
                    .fieldLabel()
                Spacer(minLength: 0)
                Text(reps?.formatted() ?? "N/A")
                    .fieldButton()
                    .underlined(canSaveExercise || hasMetrics ? Color.accentColor : Color.red)
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func DistanceField() -> some View {
        NavigationLinkNoChevron {
            ExerciseDistanceEditView(distance: $distance)
        } label: {
            HStack {
                Text("Distance")
                    .fieldLabel()
                Spacer(minLength: 0)
                Text(distance?.formatted() ?? "N/A")
                    .fieldButton()
                    .underlined(canSaveExercise || hasMetrics ? Color.accentColor : Color.red)
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func DurationField() -> some View {
        NavigationLinkNoChevron {
            ExerciseDurationEditView(duration: $duration)
        } label: {
            HStack {
                Text("Duration")
                    .fieldLabel()
                Spacer(minLength: 0)
                Text(duration?.formatted() ?? "N/A")
                    .fieldButton()
                    .underlined(canSaveExercise || hasMetrics ? Color.accentColor : Color.red)
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func AddExerciseButton() -> some View {
        HStack {
            Spacer()
            Button {
                saveExercise()
            } label: {
                Text("Add to \(workoutSection.name)")
                    .buttonDefaultModifiers()
            }
            .disabled(exerciseToSave == nil)
        }
        .workoutExerciseRow()
    }
}

fileprivate extension View {
    func fieldLabel() -> some View {
        self
            .font(.subheadline)
    }
}

#Preview {
    NavigationStack {
        List {
            Section {
                WorkoutViewNewExerciseSection(workoutSection: .sampleWarmup)
            }
        }
        .listDefaultModifiers()
    }
}
