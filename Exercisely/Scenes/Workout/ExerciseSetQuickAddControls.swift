//
//  ExerciseSetQuickAddControls.swift
//  Exercisely
//
//  Created by Jason Vance on 3/15/25.
//

import SwiftUI

struct ExerciseSetQuickAddControls: View {
    
    private let workoutSection: Workout.Section
    private let currentExercise: Workout.Exercise
    
    @State private var newSetWeight: Weight?
    @State private var newSetReps: Workout.Exercise.Reps?
    @State private var newSetDistance: Distance?
    @State private var newSetDuration: Workout.Exercise.Duration?
    
    @State private var showWeightEditor: Bool = false
    @State private var showRepsEditor: Bool = false
    @State private var showDistanceEditor: Bool = false
    @State private var showDurationEditor: Bool = false

    init(for exercise: Workout.Exercise, in workoutSection: Workout.Section) {
        self.workoutSection = workoutSection
        self.currentExercise = exercise
        
        self._newSetWeight = .init(initialValue: exercise.weight)
        self._newSetReps = .init(initialValue: exercise.reps)
        self._newSetDistance = .init(initialValue: exercise.distance)
        self._newSetDuration = .init(initialValue: exercise.duration)
    }
    
    private var exerciseToSave: Workout.Exercise? {
        let exercise = Workout.Exercise(
            name: currentExercise.name,
            weight: newSetWeight,
            reps: newSetReps,
            distance: newSetDistance,
            duration: newSetDuration
        )
        
        guard let exercise = exercise else {
            return nil
        }
        
        return exercise
    }
    
    private func saveExercise() {
        guard let exercise = exerciseToSave else {
            print("Failed to create Exercise to save")
            return
        }
        
        workoutSection.append(exercise: exercise)
    }
    
    var body: some View {
        HStack {
            Bullet().hidden()
            WeightField()
            RepsField()
            DistanceField()
            DurationField()
            Spacer(minLength: 0)
            AddNewSetButton()
        }
        .workoutExerciseRow()
        .navigationDestination(isPresented: $showWeightEditor) {
            ExerciseWeightEditView(weight: $newSetWeight)
        }
        .navigationDestination(isPresented: $showRepsEditor) {
            ExerciseRepsEditView(reps: $newSetReps)
        }
        .navigationDestination(isPresented: $showDistanceEditor) {
            ExerciseDistanceEditView(distance: $newSetDistance)
        }
        .navigationDestination(isPresented: $showDurationEditor) {
            ExerciseDurationEditView(duration: $newSetDuration)
        }
    }
    
    @ViewBuilder private func WeightField() -> some View {
        VStack(alignment: .leading) {
            Text("Weight")
                .font(.caption2)
            Button {
                showWeightEditor = true
            } label: {
                Text(newSetWeight?.formatted() ?? "N/A")
                    .fieldButton()
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    @ViewBuilder private func RepsField() -> some View {
        VStack(alignment: .leading) {
            Text("Reps")
                .font(.caption2)
            Button {
                showRepsEditor = true
            } label: {
                Text(newSetReps?.formatted() ?? "N/A")
                    .fieldButton()
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    @ViewBuilder private func DistanceField() -> some View {
        VStack(alignment: .leading) {
            Text("Distance")
                .font(.caption2)
            Button {
                showDistanceEditor = true
            } label: {
                Text(newSetDistance?.formatted() ?? "N/A")
                    .fieldButton()
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    @ViewBuilder private func DurationField() -> some View {
        VStack(alignment: .leading) {
            Text("Duration")
                .font(.caption2)
            Button {
                showDurationEditor = true
            } label: {
                Text(newSetDuration?.formatted() ?? "N/A")
                    .fieldButton()
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    @ViewBuilder private func AddNewSetButton() -> some View {
        Button {
            saveExercise()
        } label: {
            Text("Add Set")
                .buttonDefaultModifiers()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

fileprivate extension View {
    func controlButton() -> some View {
        self
            .font(.caption)
            .foregroundColor(Color.text)
            .buttonStyle(BorderlessButtonStyle())
            .frame(width: 40, height: 32)
            .background {
                RoundedRectangle(cornerRadius: .buttonCornerRadius, style: .continuous)
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundStyle(Color.accentColor)
            }
    }
}

#Preview {
    NavigationStack {
        List {
            WorkoutViewExerciseRow(.sampleVariableWeightAndRepSet, in: .sampleWorkout)
            ExerciseSetQuickAddControls(for: .sampleMachineShoulderPress, in: .sampleWarmup)
        }
        .listDefaultModifiers()
    }
}
