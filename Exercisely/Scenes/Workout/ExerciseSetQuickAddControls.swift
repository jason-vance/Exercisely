//
//  ExerciseSetQuickAddControls.swift
//  Exercisely
//
//  Created by Jason Vance on 3/15/25.
//

import SwiftUI

struct ExerciseSetQuickAddControls: View {
    
    enum Mode {
        case add
        case edit
    }
    
    private let workoutSection: Workout.Section
    private let currentExercise: Workout.Exercise
    
    @State private var newSetWeight: Weight?
    @State private var newSetReps: Workout.Exercise.Reps?
    @State private var newSetDistance: Distance?
    @State private var newSetDuration: Workout.Exercise.Duration?
    
    // .navigationDestination cannot be inside of a lazy container.
    // So, I have to use these props to reach back outside of the
    // List on WorkoutView.
    @Binding private var weightEditor: Binding<Weight?>?
    @Binding private var repsEditor: Binding<Workout.Exercise.Reps?>?
    @Binding private var distanceEditor: Binding<Distance?>?
    @Binding private var durationEditor: Binding<Workout.Exercise.Duration?>?
    
    private var __mode: Mode = .add
    @State private var mode: Mode = .add

    init(
        for exercise: Workout.Exercise,
        in workoutSection: Workout.Section,
        weightEditor: Binding<Binding<Weight?>?>,
        repsEditor: Binding<Binding<Workout.Exercise.Reps?>?>,
        distanceEditor: Binding<Binding<Distance?>?>,
        durationEditor: Binding<Binding<Workout.Exercise.Duration?>?>
    ) {
        self.workoutSection = workoutSection
        self.currentExercise = exercise
        
        self._newSetWeight = .init(initialValue: exercise.weight)
        self._newSetReps = .init(initialValue: exercise.reps)
        self._newSetDistance = .init(initialValue: exercise.distance)
        self._newSetDuration = .init(initialValue: exercise.duration)
        
        self._weightEditor = weightEditor
        self._repsEditor = repsEditor
        self._distanceEditor = distanceEditor
        self._durationEditor = durationEditor
    }
    
    public func mode(_ mode: Mode) -> ExerciseSetQuickAddControls {
        var view = self
        view.__mode = mode
        return view
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
    
    private var canSaveExercise: Bool { exerciseToSave != nil }
    
    private var hasChanges: Bool {
        currentExercise.weight != newSetWeight
        || currentExercise.reps != newSetReps
        || currentExercise.distance != newSetDistance
        || currentExercise.duration != newSetDuration
    }
    
    private func saveExercise() {
        guard let exercise = exerciseToSave else {
            print("Failed to create Exercise to save")
            return
        }
        
        switch mode {
        case .edit:
            currentExercise.weight = newSetWeight
            currentExercise.reps = newSetReps
            currentExercise.distance = newSetDistance
            currentExercise.duration = newSetDuration
            break
        case .add:
            workoutSection.insert(exercise: exercise, after: currentExercise)
            break
        }
    }
    
    var body: some View {
        HStack {
            Bullet().hidden()
            WeightField()
            RepsField()
            DistanceField()
            DurationField()
            Spacer()
            AddNewSetButton()
        }
        .padding()
        .workoutExerciseRow()
        .onChange(of: __mode, initial: true) { _, mode in self.mode = mode }
    }
    
    @ViewBuilder private func WeightField() -> some View {
        VStack(alignment: .leading) {
            Text("Weight")
                .font(.caption2)
            Button {
                weightEditor = .init(
                    get: { newSetWeight },
                    set: { newSetWeight = $0 }
                )
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
                repsEditor = .init(
                    get: { newSetReps },
                    set: { newSetReps = $0 }
                )
            } label: {
                Text(newSetReps?.formatted() ?? "N/A")
                    .fieldButton()
                    .underlined(canSaveExercise ? Color.accentColor : Color.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    @ViewBuilder private func DistanceField() -> some View {
        VStack(alignment: .leading) {
            Text("Distance")
                .font(.caption2)
            Button {
                distanceEditor = .init(
                    get: { newSetDistance },
                    set: { newSetDistance = $0 }
                )
            } label: {
                Text(newSetDistance?.formatted() ?? "N/A")
                    .fieldButton()
                    .underlined(canSaveExercise ? Color.accentColor : Color.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    @ViewBuilder private func DurationField() -> some View {
        VStack(alignment: .leading) {
            Text("Duration")
                .font(.caption2)
            Button {
                durationEditor = .init(
                    get: { newSetDuration },
                    set: { newSetDuration = $0 }
                )
            } label: {
                Text(newSetDuration?.formatted() ?? "N/A")
                    .fieldButton()
                    .underlined(canSaveExercise ? Color.accentColor : Color.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    @ViewBuilder private func AddNewSetButton() -> some View {
        Button {
            saveExercise()
        } label: {
            Text(mode == .add ? "Add" : "Save")
                .font(.footnote)
                .lineLimit(1)
                .buttonDefaultModifiers()
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!canSaveExercise)
        .opacity(mode == .add || hasChanges ? 1 : 0)
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
            ExerciseSetQuickAddControls(
                for: .sampleMachineShoulderPress,
                in: .sampleWarmup,
                weightEditor: .init(
                    get: { .init(get: { nil }, set: { _ in })},
                    set: { _ in }
                ),
                repsEditor: .init(
                    get: { .init(get: { nil }, set: { _ in })},
                    set: { _ in }
                ),
                distanceEditor: .init(
                    get: { .init(get: { nil }, set: { _ in })},
                    set: { _ in }
                ),
                durationEditor: .init(
                    get: { .init(get: { nil }, set: { _ in })},
                    set: { _ in }
                )
            )
            ExerciseSetQuickAddControls(
                for: .sampleMachineShoulderPress,
                in: .sampleWarmup,
                weightEditor: .init(
                    get: { .init(get: { nil }, set: { _ in })},
                    set: { _ in }
                ),
                repsEditor: .init(
                    get: { .init(get: { nil }, set: { _ in })},
                    set: { _ in }
                ),
                distanceEditor: .init(
                    get: { .init(get: { nil }, set: { _ in })},
                    set: { _ in }
                ),
                durationEditor: .init(
                    get: { .init(get: { nil }, set: { _ in })},
                    set: { _ in }
                )
            )
            .mode(.edit)
        }
        .listDefaultModifiers()
    }
}
