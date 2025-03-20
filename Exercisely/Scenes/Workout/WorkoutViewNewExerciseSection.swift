//
//  WorkoutViewNewExerciseSection.swift
//  Exercisely
//
//  Created by Jason Vance on 3/16/25.
//

import SwiftUI
import SwiftData

//TODO: Show what you did the last time you logged this exercise
struct WorkoutViewNewExerciseSection: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Model
    class PendingSuperset {
        private(set) var exercises: [Workout.Exercise]
        
        init(exercises: [Workout.Exercise]) {
            self.exercises = exercises
        }
        
        var sequenceEstablished: Bool {
            Set(exercises.map(\.name)).count < exercises.map(\.name).count
        }
        
        var sequenceLength: Int? {
            guard sequenceEstablished else { return nil }
            return Set(exercises.map(\.name)).count
        }
        
        func append(_ exercise: Workout.Exercise) {
            exercises.append(exercise)
        }
        
        var expectedNextExercise: Workout.Exercise? {
            let orderedExercises = exercises.sorted(by: { $0.order < $1.order })
            guard let sequenceLength = sequenceLength else {
                if orderedExercises.count > 1 {
                    return orderedExercises.first
                }
                return nil
            }
            
            return orderedExercises[orderedExercises.count - sequenceLength]
        }
    }
    
    private var defaultRest: Workout.Exercise.Duration {
        .init(value: 90, unit: .seconds)!
    }
    
    private let weightStepValue: Double = 5
    private let repsStepValue: Int = 1
    private let distanceStepValue: Double = 1
    private let durationStepValue: Double = 5
    private let restStepValue: Double = 5

    private enum AddType: CaseIterable {
        case startNewExercise
        case continueSet
        case startSuperset
        case continueSuperset
        case startDropSet
        case continueDropSet

        var menuTitle: String {
            switch self {
            case .startNewExercise:
                return "Start New Exercise"
            case .continueSet:
                return "Add a Set"
            case .startSuperset:
                return "Start New Superset"
            case .continueSuperset:
                return "Add to Superset"
            case .startDropSet:
                return "Start New Drop Set"
            case .continueDropSet:
                return "Add a Drop Set"
            }
        }
        
        func actionTitle(workoutSection: Workout.Section) -> String {
            switch self {
            case .startNewExercise:
                return "Add to \"\(workoutSection.name)\""
            case .continueSet:
                return "Add Set"
            case .startSuperset:
                return "Start Superset"
            case .continueSuperset:
                return "Add to Superset"
            case .startDropSet:
                return "Start Drop Set"
            case .continueDropSet:
                return "Add Drop Set"
            }
        }
    }
    
    let workoutSectionId: Workout.Section.ID
    @Query private var workoutSections: [Workout.Section]
    private var workoutSection: Workout.Section? {
        workoutSections.first(where: { $0.id == workoutSectionId })
    }
    
    @State private var addType: AddType? = nil

    @State private var name: Workout.Exercise.Name? = nil
    @State private var weight: Weight? = nil
    @State private var reps: Workout.Exercise.Reps? = nil
    @State private var distance: Distance? = nil
    @State private var duration: Workout.Exercise.Duration? = nil
    @State private var rest: Workout.Exercise.Duration? = nil
    
    @State private var showSupersetInfo: Bool = false
    
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
        return exercise
    }
    
    private var canSaveExercise: Bool { exerciseToSave != nil }
    private var hasName: Bool { name != nil }
    private var hasMetrics: Bool { reps != nil || distance != nil || duration != nil }
    
    private func handleSupersetTracking(exercise: Workout.Exercise) {
        switch addType {
        case .startSuperset:
            for pendingSuperset in pendingSupersets {
                modelContext.delete(pendingSuperset)
            }
            modelContext.insert(PendingSuperset(exercises: [exercise]))
            break
        case .continueSuperset:
            pendingSuperset?.append(exercise)
            break
        default:
            for pendingSuperset in pendingSupersets {
                modelContext.delete(pendingSuperset)
            }
            break
        }
    }

    private func saveExercise() {
        guard let exercise = exerciseToSave else {
            print("Failed to create Exercise to save")
            return
        }
        
        withAnimation(.snappy) {
            workoutSection?.append(exercise: exercise)
            handleSupersetTracking(exercise: exercise)
                        
            addType = {
                switch addType {
                case .startSuperset, .continueSuperset:
                    return .continueSuperset
                case .startDropSet, .continueDropSet:
                    return .continueDropSet
                default:
                    return .continueSet
                }
            }()
            initializeFields()
        }
    }
    
    //TODO: Make a setting for default rest value
    private func initializeFields() {
        switch addType {
        case .startNewExercise:
            name = nil
            weight = nil
            reps = nil
            distance = nil
            duration = nil
            rest = defaultRest // So users don't accidentally start a drop set
            break
        case .continueSet:
            let setExercise = workoutSection?.sortedExercises.last
                
            self.name = setExercise?.name
            self.weight = setExercise?.weight
            self.reps = setExercise?.reps
            self.distance = setExercise?.distance
            self.duration = setExercise?.duration
            self.rest = setExercise?.rest ?? defaultRest

                break
        case .startSuperset:
            name = nil
            weight = nil
            reps = nil
            distance = nil
            duration = nil
            rest = nil
            break
        case .continueSuperset:
            let setExercise = pendingSuperset?.expectedNextExercise
            
            self.name = setExercise?.name
            self.weight = setExercise?.weight
            self.reps = setExercise?.reps
            self.distance = setExercise?.distance
            self.duration = setExercise?.duration
            self.rest = setExercise?.rest
            
            break
        case .startDropSet:
            name = nil
            weight = nil
            reps = nil
            distance = nil
            duration = nil
            rest = nil
            break
        case .continueDropSet:
            let setExercise = workoutSection?.sortedExercises.last
            
            self.name = setExercise?.name
            self.weight = setExercise?.weight?.subtracting(weightStepValue)
            self.reps = setExercise?.reps?.subtracting(repsStepValue)
            self.distance = setExercise?.distance
            self.duration = setExercise?.duration
            self.rest = nil
            
            break
        case .none:
            break
        }
    }
    
    private var previousExercise: Workout.Exercise? {
        workoutSection?.sortedExercises.last
    }
    
    private var currentExerciseGroup: ExerciseGroup? {
        workoutSection?.groupedExercises.last
    }
    
    @Query private var pendingSupersets: [PendingSuperset]
    private var pendingSuperset: PendingSuperset? {
        if let pendingSuperset = pendingSupersets.first {
            return pendingSuperset
        } else {
            return nil
        }
    }
    
    private var availableAddTypeOptions: [AddType] {
        switch currentExerciseGroup {
        case .set:
            if pendingSuperset != nil {
                [ .continueSuperset, .startNewExercise, .startDropSet, .startSuperset ]
            } else {
                [ .continueSet, .continueDropSet, .startNewExercise, .startDropSet, .startSuperset ]
            }
        case .dropSet:
            [ .continueDropSet, .startNewExercise, .startDropSet, .startSuperset ]
        case .superset:
            [ .continueSuperset, .startNewExercise, .startDropSet, .startSuperset ]
        case .none:
            [ .startNewExercise, .startDropSet, .startSuperset ]
        }
    }
    
    private var isNameFieldDisabled: Bool {
        switch addType {
        case .startNewExercise, .startDropSet, .startSuperset, .none:
        return false
        case .continueSet, .continueDropSet:
        return true
        case .continueSuperset:
        return pendingSuperset != nil && pendingSuperset!.sequenceEstablished
        }
    }
    
    private var isRestFieldDisabled: Bool {
        [ AddType.startDropSet, AddType.continueDropSet ].contains(addType)
    }
    
    private func onChangeAddType(old: AddType?, new: AddType?) {
        guard old != new else { return }
        initializeFields()
    }
    
    private func onChangePreviousExercise(old: Workout.Exercise?, new: Workout.Exercise?) {
        guard old !== new || addType == nil else { return }
        guard let exerciseGroup = currentExerciseGroup, let new = new else {
            addType = .startNewExercise
            return
        }

        if let pendingSuperset = pendingSuperset, pendingSuperset.exercises.contains(new) {
            addType = .continueSuperset
        } else {
            switch exerciseGroup {
            case .dropSet:
                addType = .continueDropSet
            default:
                addType = addType == nil ? .continueSet : addType
            }
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
        .onChange(of: previousExercise, initial: true) { onChangePreviousExercise(old: $0, new: $1) }
    }
    
    @ViewBuilder private func AddTypeMenu() -> some View {
        if let addType = addType {
            HStack {
                Menu {
                    ForEach(availableAddTypeOptions, id: \.self) { addType in
                        Button(addType.menuTitle) { self.addType = addType }
                    }
                } label: {
                    Text(addType.menuTitle)
                        .fieldButton()
                }
                Spacer()
                let showSuperSetInfoIcon = addType == .startSuperset || addType == .continueSuperset
                Button {
                    showSupersetInfo = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(Color.accentColor)
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(showSuperSetInfoIcon ? 1 : 0)
                .disabled(!showSuperSetInfoIcon)
                .alert("Your exercises might look a little weird as you progress through your superset.\n\nBut, don't worry!\n\nIt will all look fine in the end.", isPresented: $showSupersetInfo) {}
            }
            .workoutExerciseRow()
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
        .disabled(isNameFieldDisabled)
    }
    
    //TODO: Is there a way to share this view code (see ExerciseDetailView)
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
            .disabled(isRestFieldDisabled)
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func AddExerciseButton() -> some View {
        if let addType = addType, let workoutSection = workoutSection {
            HStack {
                Spacer()
                Button {
                    saveExercise()
                } label: {
                    Text(addType.actionTitle(workoutSection: workoutSection))
                        .buttonDefaultModifiers()
                        .contentTransition(.numericText())
                }
                .disabled(exerciseToSave == nil)
                .animation(.snappy, value: addType)
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
                    workoutSectionId: Workout.Section.sampleWorkout.id,
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
