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
    
    // .navigationDestination cannot be inside of a lazy container.
    // So, I have to use these props to let ExerciseSetQuickAddControls
    // reach back outside to the List in this view.
    @State private var weightEditor: Binding<Weight?>? = nil
    @State private var repsEditor: Binding<Workout.Exercise.Reps?>? = nil
    @State private var distanceEditor: Binding<Distance?>? = nil
    @State private var durationEditor: Binding<Workout.Exercise.Duration?>? = nil
    @State private var restEditor: Binding<Workout.Exercise.Duration?>? = nil
    
    private var showWeightEditor: Binding<Bool> {
        .init(
            get: { weightEditor != nil },
            set: { isPresented in weightEditor = isPresented ? weightEditor : nil }
        )
    }
    private var showRepsEditor: Binding<Bool> {
        .init(
            get: { repsEditor != nil },
            set: { isPresented in repsEditor = isPresented ? repsEditor : nil }
        )
    }
    private var showDistanceEditor: Binding<Bool> {
        .init(
            get: { distanceEditor != nil },
            set: { isPresented in distanceEditor = isPresented ? distanceEditor : nil }
        )
    }
    private var showDurationEditor: Binding<Bool> {
        .init(
            get: { durationEditor != nil },
            set: { isPresented in durationEditor = isPresented ? durationEditor : nil }
        )
    }
    private var showRestEditor: Binding<Bool> {
        .init(
            get: { restEditor != nil },
            set: { isPresented in restEditor = isPresented ? restEditor : nil }
        )
    }
    
    
    
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
        .navigationDestination(isPresented: showWeightEditor) {
            ExerciseWeightEditView(weight: .init(
                get: { weightEditor?.wrappedValue },
                set: { weightEditor?.wrappedValue = $0 }
            ))
        }
        .navigationDestination(isPresented: showRepsEditor) {
            ExerciseRepsEditView(reps: .init(
                get: { repsEditor?.wrappedValue },
                set: { repsEditor?.wrappedValue = $0 }
            ))
        }
        .navigationDestination(isPresented: showDistanceEditor) {
            ExerciseDistanceEditView(distance: .init(
                get: { distanceEditor?.wrappedValue },
                set: { distanceEditor?.wrappedValue = $0 }
            ))
        }
        .navigationDestination(isPresented: showDurationEditor) {
            ExerciseDurationEditView(duration: .init(
                get: { durationEditor?.wrappedValue },
                set: { durationEditor?.wrappedValue = $0 }
            ), mode: .duration)
        }
        .navigationDestination(isPresented: showRestEditor) {
            ExerciseDurationEditView(duration: .init(
                get: { restEditor?.wrappedValue },
                set: { restEditor?.wrappedValue = $0 }
            ), mode: .rest)
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
                weightEditor = $weight
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
                repsEditor = $reps
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
                distanceEditor = $distance
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
                durationEditor = $duration
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
                restEditor = $rest
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
