//
//  WorkoutViewNewExerciseSection.swift
//  Exercisely
//
//  Created by Jason Vance on 3/16/25.
//

import SwiftUI

struct WorkoutViewNewExerciseSection: View {
    
    private enum AddType: CaseIterable {
        case exercise
        case set
        case superset
        case dropset
        
        var title: String {
            switch self {
            case .exercise:
                return "New Exercise"
            case .set:
                return "New Set"
            case .superset:
                return "Continue Superset"
            case .dropset:
                return "Continue Dropset"
            }
        }
        
        func actionTitle(workoutSection: Workout.Section, previousExercise: Workout.Exercise?) -> String {
            switch self {
            case .exercise:
                return "Add to \"\(workoutSection.name)\""
            case .set:
                return "Add Set to \"\(previousExercise?.name.formatted() ?? "Exercise")\""
            case .superset:
                return "Add to Superset"
            case .dropset:
                return "Add to Dropset"
            }
            
        }
    }
    
    //TODO: I should probably get this via query, so that things can update
    let workoutSection: Workout.Section
    
    @State private var addType: AddType = .set

    //TODO: If name changes, then change addType to something other than 'set'
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
    
    private var previousExercise: Workout.Exercise? {
        workoutSection.sortedExercises.last
    }
    
    private func onUpdate(addType: AddType) {
        //TODO: Set up intial state for each case
        switch addType {
        case .set:
            if let setExercise = workoutSection.sortedExercises.last {
                self.name = setExercise.name
                self.weight = setExercise.weight
                self.reps = setExercise.reps
                self.distance = setExercise.distance
                self.duration = setExercise.duration
            }
            break
        default:
            break
        }
    }
    
    private func onUpdate(previousExercise: Workout.Exercise?) {
        //If there is no previousExercise, we can only add to the workout section
        if previousExercise == nil {
            addType = .exercise
        }
    }
    
    var body: some View {
        Section {
            AddTypeMenu()
            NameField()
            WeightField()
            RepsField()
            DistanceField()
            DurationField()
            AddExerciseButton()
        }
        .foregroundStyle(Color.text)
        .onChange(of: addType, initial: true) { _, addType in onUpdate(addType: addType) }
        .onChange(of: previousExercise, initial: true) { _, previousExercise in onUpdate(previousExercise: previousExercise) }
    }
    
    @ViewBuilder private func AddTypeMenu() -> some View {
        Menu {
            ForEach(AddType.allCases, id: \.self) { addType in
                Button(addType.title) { self.addType = addType }
            }
        } label: {
            Text(addType.title)
                .fieldButton()
        }
        .workoutExerciseRow()
        .disabled(previousExercise == nil)
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
        .disabled(addType == .set)
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
                Text(addType.actionTitle(
                    workoutSection: workoutSection,
                    previousExercise: previousExercise
                ))
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
