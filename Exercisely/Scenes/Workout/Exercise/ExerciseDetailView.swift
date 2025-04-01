//
//  ExerciseDetailView.swift
//  Exercisely
//
//  Created by Jason Vance on 3/20/25.
//

import SwiftUI

struct ExerciseDetailView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @StateObject private var userSettings = UserSettings()
    
    @Binding var exercise: Workout.Exercise
    @State private var weight: Weight? = nil
    @State private var reps: Workout.Exercise.Reps? = nil
    @State private var distance: Distance? = nil
    @State private var duration: Workout.Exercise.Duration? = nil
    @State private var rest: Workout.Exercise.Duration? = nil
    @State private var hasPopulatedFields: Bool = false
    
    private var exerciseToSave: Workout.Exercise? {
        Workout.Exercise(
            name: exercise.name,
            weight: weight,
            reps: reps,
            distance: distance,
            duration: duration,
            rest: rest,
            order: exercise.order
        )
    }
    private var canSaveExercise: Bool { exerciseToSave != nil }
    private var hasMetrics: Bool { reps != nil || distance != nil || duration != nil }
        
    @State private var showWeightEditor: Bool = false
    @State private var showRepsEditor: Bool = false
    @State private var showDistanceEditor: Bool = false
    @State private var showDurationEditor: Bool = false
    @State private var showRestEditor: Bool = false
    
    init(_ exercise: Binding<Workout.Exercise>) {
        self._exercise = exercise
    }
    
    private func prepopulateFields() {
        if hasPopulatedFields { return }
        
        weight = exercise.weight
        reps = exercise.reps
        distance = exercise.distance
        duration = exercise.duration
        rest = exercise.rest
        
        hasPopulatedFields = true
    }
    
    private func updateExercise() {
        guard let exerciseToSave = exerciseToSave else {
            print("Could not save exercise")
            return
        }
        
        self.exercise.weight = exerciseToSave.weight
        self.exercise.reps = exerciseToSave.reps
        self.exercise.distance = exerciseToSave.distance
        self.exercise.duration = exerciseToSave.duration
        self.exercise.rest = exerciseToSave.rest
        
        presentation.wrappedValue.dismiss()
    }
    
    var body: some View {
        List {
            if let exerciseToSave {
                WorkoutViewExerciseRow(.set([exerciseToSave]), in: .init(name: ""))
                    .disabled(true)
            } else {
                Text("Sorry, these values are invalid")
                    .workoutExerciseRow()
            }
            WeightField()
            RepsField()
            DistanceField()
            DurationField()
            RestField()
            if exerciseToSave == nil {
                Text("An exercise needs at least one of reps, distance, or duration")
                    .workoutExerciseRow()
            }
        }
        .listDefaultModifiers()
        .toolbar { Toolbar() }
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .animation(.snappy, value: exercise)
        .animation(.snappy, value: weight)
        .animation(.snappy, value: reps)
        .animation(.snappy, value: distance)
        .animation(.snappy, value: duration)
        .animation(.snappy, value: rest)
        .onAppear { prepopulateFields() }
        .navigationDestination(isPresented: $showWeightEditor) {
            ExerciseWeightEditView(weight: $weight)
        }
        .navigationDestination(isPresented: $showRepsEditor) {
            ExerciseRepsEditView(reps: $reps)
        }
        .navigationDestination(isPresented: $showDistanceEditor) {
            ExerciseDistanceEditView(distance: $distance)
        }
        .navigationDestination(isPresented: $showDurationEditor) {
            ExerciseDurationEditView(duration: $duration, mode: .duration)
        }
        .navigationDestination(isPresented: $showRestEditor) {
            ExerciseDurationEditView(duration: $rest, mode: .rest)
        }
    }
    
    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(exercise.name.formatted())
                .bold(true)
                .foregroundStyle(Color.text)
        }
        ToolbarItem(placement: .topBarLeading) {
            BackButton()
        }
        ToolbarItem(placement: .topBarTrailing) {
            SaveButton()
        }
    }
    
    @ViewBuilder private func BackButton() -> some View {
        Button {
            presentation.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(Color.accentColor)
        }
    }
    
    @ViewBuilder private func SaveButton() -> some View {
        Button {
            updateExercise()
        } label: {
            Image(systemName: "checkmark")
                .foregroundStyle(Color.accentColor)
        }
        .disabled(!canSaveExercise)
    }
    
    //TODO: Is there a way to share this view code (see WorkoutViewNewExerciseSection)
    @ViewBuilder private func WeightField() -> some View {
        HStack {
            Text("Weight")
                .fieldLabel()
            Spacer()
            if weight != nil {
                HStack {
                    Button("-\(userSettings.weightStepperValue.formatted())") {
                        weight = weight?.subtracting(userSettings.weightStepperValue)
                    }
                    .buttonDefaultModifiers()
                    .buttonStyle(PlainButtonStyle())
                    Button("+\(userSettings.weightStepperValue.formatted())") {
                        weight = weight?.adding(userSettings.weightStepperValue)
                    }
                    .buttonDefaultModifiers()
                    .buttonStyle(PlainButtonStyle())
                }
            }
            Button {
                showWeightEditor = true
            } label: {
                Text(weight?.formatted() ?? "N/A")
                    .fieldButton()
            }
            .buttonStyle(PlainButtonStyle())
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func RepsField() -> some View {
        HStack {
            Text("Reps")
                .fieldLabel()
            Spacer()
            if reps != nil {
                HStack {
                    Button("-\(userSettings.repsStepperValue.formatted())") {
                        reps = reps?.subtracting(userSettings.repsStepperValue)
                    }
                    .buttonDefaultModifiers()
                    .buttonStyle(PlainButtonStyle())
                    Button("+\(userSettings.repsStepperValue.formatted())") {
                        reps = reps?.adding(userSettings.repsStepperValue)
                    }
                    .buttonDefaultModifiers()
                    .buttonStyle(PlainButtonStyle())
                }
            }
            Button {
                showRepsEditor = true
            } label: {
                Text(reps?.formatted() ?? "N/A")
                    .fieldButton()
                    .underlined(canSaveExercise || hasMetrics ? Color.accentColor : Color.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func DistanceField() -> some View {
        HStack {
            Text("Distance")
                .fieldLabel()
            Spacer()
            if distance != nil {
                HStack {
                    Button("-\(userSettings.distanceStepperValue.formatted())") {
                        distance = distance?.subtracting(userSettings.distanceStepperValue)
                    }
                    .buttonDefaultModifiers()
                    .buttonStyle(PlainButtonStyle())
                    Button("+\(userSettings.distanceStepperValue.formatted())") {
                        distance = distance?.adding(userSettings.distanceStepperValue)
                    }
                    .buttonDefaultModifiers()
                    .buttonStyle(PlainButtonStyle())
                }
            }
            Button {
                showDistanceEditor = true
            } label: {
                Text(distance?.formatted() ?? "N/A")
                    .fieldButton()
                    .underlined(canSaveExercise || hasMetrics ? Color.accentColor : Color.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func DurationField() -> some View {
        HStack {
            Text("Duration")
                .fieldLabel()
            Spacer()
            if duration != nil {
                HStack {
                    Button("-\(userSettings.durationStepperValue.formatted())") {
                        duration = duration?.subtracting(userSettings.durationStepperValue)
                    }
                    .buttonDefaultModifiers()
                    .buttonStyle(PlainButtonStyle())
                    Button("+\(userSettings.durationStepperValue.formatted())") {
                        duration = duration?.adding(userSettings.durationStepperValue)
                    }
                    .buttonDefaultModifiers()
                    .buttonStyle(PlainButtonStyle())
                }
            }
            Button {
                showDurationEditor = true
            } label: {
                Text(duration?.formatted() ?? "N/A")
                    .fieldButton()
                    .underlined(canSaveExercise || hasMetrics ? Color.accentColor : Color.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .workoutExerciseRow()
    }
    
    //TODO: Should I add tooltips to each of these fields to explain exactly what they are
    // ^^ In case its confusing to users
    @ViewBuilder private func RestField() -> some View {
        HStack {
            Text("Rest")
                .fieldLabel()
            Spacer()
            if rest != nil {
                HStack {
                    Button("-\(userSettings.restStepperValue.formatted())") {
                        rest = rest?.subtracting(userSettings.restStepperValue)
                    }
                    .buttonDefaultModifiers()
                    .buttonStyle(PlainButtonStyle())
                    Button("+\(userSettings.restStepperValue.formatted())") {
                        rest = rest?.adding(userSettings.restStepperValue)
                    }
                    .buttonDefaultModifiers()
                    .buttonStyle(PlainButtonStyle())
                }
            }
            Button {
                showRestEditor = true
            } label: {
                Text(rest?.formatted() ?? "N/A")
                    .fieldButton()
                    .underlined()
            }
            .buttonStyle(PlainButtonStyle())
        }
        .workoutExerciseRow()
    }
}

#Preview {
    var exercise = Workout.Exercise.sampleTurkishGetUp
    
    NavigationStack {
        ExerciseDetailView(.init(
            get: { exercise },
            set: { exercise = $0 }
        ))
    }
}
