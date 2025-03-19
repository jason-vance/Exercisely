//
//  WorkoutViewNewExerciseSection.swift
//  Exercisely
//
//  Created by Jason Vance on 3/16/25.
//

import SwiftUI

struct WorkoutViewNewExerciseSection: View {
    
    private var defaultRest: Workout.Exercise.Duration {
        .init(value: 90, unit: .seconds)!
    }
    
    private let weightStepValue: Double = 5
    private let repsStepValue: Int = 1
    private let distanceStepValue: Double = 1
    private let durationStepValue: Double = 5
    private let restStepValue: Double = 5

    private enum AddType: CaseIterable {
        case exercise
        case set
        case superset
        case dropset
        
        var title: String {
            switch self {
            case .exercise:
                return "Start New Exercise"
            case .set:
                return "Add a Set"
            case .superset:
                return "Continue Superset"
            case .dropset:
                return "Add a Dropset"
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
    
    @State private var addType: AddType? = nil

    @State private var name: Workout.Exercise.Name? = nil
    @State private var weight: Weight? = nil
    @State private var reps: Workout.Exercise.Reps? = nil
    @State private var distance: Distance? = nil
    @State private var duration: Workout.Exercise.Duration? = nil
    @State private var rest: Workout.Exercise.Duration? = nil

    // .navigationDestination cannot be inside of a lazy container.
    // So, I have to use these props to reach back outside of the
    // List on WorkoutView.
    @Binding var weightEditor: Binding<Weight?>?
    @Binding var repsEditor: Binding<Workout.Exercise.Reps?>?
    @Binding var distanceEditor: Binding<Distance?>?
    @Binding var durationEditor: Binding<Workout.Exercise.Duration?>?
    @Binding var restEditor: Binding<Workout.Exercise.Duration?>?

    private var exerciseToSave: Workout.Exercise? {
        guard let name = name else {
            return nil
        }
        
        let exercise = Workout.Exercise(
            name: name,
            weight: weight,
            reps: reps,
            distance: distance,
            duration: duration,
            rest: rest
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
            initializeFields()
            addType = addType == .exercise ? .set : addType
        }
    }
    
    //TODO: Make a setting for default rest value
    private func initializeFields() {
        switch addType {
        case .exercise:
            name = nil
            weight = nil
            reps = nil
            distance = nil
            duration = nil
            rest = defaultRest // So users don't accidentally start a drop set
            break
        case .set:
            if let setExercise = workoutSection.sortedExercises.last {
                self.name = setExercise.name
                self.weight = setExercise.weight
                self.reps = setExercise.reps
                self.distance = setExercise.distance
                self.duration = setExercise.duration
                self.rest = setExercise.rest
            }
            break
        case .superset:
            //TODO: MVP: Find the next exercise in the superset and fill in the fields
            break
        case .dropset:
            if let setExercise = workoutSection.sortedExercises.last {
                self.name = setExercise.name
                self.weight = setExercise.weight?.subtracting(weightStepValue)
                self.reps = setExercise.reps?.subtracting(repsStepValue)
                self.distance = setExercise.distance?.subtracting(distanceStepValue)
                self.duration = setExercise.duration?.subtracting(durationStepValue)
                self.rest = nil
            }
            break
        case .none:
            break
        }
    }
    
    private var previousExercise: Workout.Exercise? {
        workoutSection.sortedExercises.last
    }
    
    private func onChangeAddType(old: AddType?, new: AddType?) {
        guard old != new else { return }
        initializeFields()
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
            RestField()
            AddExerciseButton()
        }
        .foregroundStyle(Color.text)
        .animation(.snappy, value: weight)
        .animation(.snappy, value: reps)
        .animation(.snappy, value: distance)
        .animation(.snappy, value: duration)
        .animation(.snappy, value: rest)
        .onChange(of: addType, initial: true) { onChangeAddType(old: $0, new: $1) }
        .onChange(of: previousExercise, initial: true) { _, previousExercise in onUpdate(previousExercise: previousExercise) }
        .onAppear { addType = addType == nil ? .set : addType}
    }
    
    @ViewBuilder private func AddTypeMenu() -> some View {
        if let addType = addType {
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
        .disabled(addType != .exercise)
    }
    
    //TODO: Add settings to change these stepper values
    @ViewBuilder private func WeightField() -> some View {
        HStack {
            Text("Weight")
                .fieldLabel()
            Spacer()
            if weight != nil {
                HStack {
                    Button("-\(weightStepValue.formatted())") {
                        weight = weight?.subtracting(weightStepValue)
                    }
                    .buttonDefaultModifiers()
                    .buttonStyle(PlainButtonStyle())
                    Button("+\(weightStepValue.formatted())") {
                        weight = weight?.adding(weightStepValue)
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
                    Button("-\(repsStepValue.formatted())") {
                        reps = reps?.subtracting(repsStepValue)
                    }
                    .buttonDefaultModifiers()
                    .buttonStyle(PlainButtonStyle())
                    Button("+\(repsStepValue.formatted())") {
                        reps = reps?.adding(repsStepValue)
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
                    Button("-\(distanceStepValue.formatted())") {
                        distance = distance?.subtracting(distanceStepValue)
                    }
                    .buttonDefaultModifiers()
                    .buttonStyle(PlainButtonStyle())
                    Button("+\(distanceStepValue.formatted())") {
                        distance = distance?.adding(distanceStepValue)
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
                    Button("-\(durationStepValue.formatted())") {
                        duration = duration?.subtracting(durationStepValue)
                    }
                    .buttonDefaultModifiers()
                    .buttonStyle(PlainButtonStyle())
                    Button("+\(durationStepValue.formatted())") {
                        duration = duration?.adding(durationStepValue)
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
                    Button("-\(restStepValue.formatted())") {
                        rest = rest?.subtracting(restStepValue)
                    }
                    .buttonDefaultModifiers()
                    .buttonStyle(PlainButtonStyle())
                    Button("+\(restStepValue.formatted())") {
                        rest = rest?.adding(restStepValue)
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
            .disabled(addType == .dropset)
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func AddExerciseButton() -> some View {
        if let addType = addType {
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
                WorkoutViewNewExerciseSection(
                    workoutSection: .sampleWorkout,
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
                    ),
                    restEditor: .init(
                        get: { .init(get: { nil }, set: { _ in })},
                        set: { _ in }
                    )
                
                )
            }
        }
        .listDefaultModifiers()
    }
}
