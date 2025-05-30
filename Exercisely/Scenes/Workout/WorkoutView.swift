//
//  WorkoutView.swift
//  Exercisely
//
//  Created by Jason Vance on 1/7/25.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
    
    private let newExerciseSectionId: String = "newExerciseSectionId"
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage("previouslyOpenedDate") private var previouslyOpenedDateInt: Int = 0
    
    @Query private var workouts: [Workout]
    
    @State private var workoutFocusString: String = ""
    @State private var date: SimpleDate = .today
    
    @FocusState private var isWorkoutFocusInFocus: Bool
    @State private var showNewExerciseControls: Bool = false
    
    @State private var showSectionOptions: Workout.Section? = nil {
        didSet {
            if showSectionOptions != nil {
                let sectionOptionsToHide = showSectionOptions
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if self.showSectionOptions == sectionOptionsToHide {
                        showSectionOptions = nil
                    }
                }
            }
        }
    }
    @State private var sectionToDelete: Workout.Section? = nil
    @State private var sectionToRename: Workout.Section? = nil
    @State private var sectionRenameString: String = ""
    
    @State private var exerciseGroupsToDelete: [ExerciseGroup] = []

    @State private var showAddSection: Bool = false
    @State private var newWorkoutSectionName: String = ""
    
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

    var workout: Workout {
        if let workout = workouts.first(where: { $0.date == date }) {
            return workout
        }
        
        let workout = Workout(date: date)
        modelContext.insert(workout)
        return workout
    }
    
    var currentSection: Workout.Section? {
        workout.sortedSections.last
    }
    
    var currentExercise: Workout.Exercise? {
        currentSection?.sortedExercises.last
    }
    
    private var hidePlayPauseWorkoutButton: Bool {
        isWorkoutFocusInFocus || workout.sections.isEmpty
    }
    
    private func addNewSectionToWorkout() {
        guard let section = Workout.Section(name: newWorkoutSectionName) else { return }
        
        withAnimation(.snappy) {
            workout.append(section: section)
            showAddSection = false
            newWorkoutSectionName = ""
            showNewExerciseControls = true
        }
    }
    
    private func removeSectionFromWorkout() {
        withAnimation(.snappy) {
            guard let sectionToDelete = sectionToDelete else { return }
            workout.remove(section: sectionToDelete)
            self.sectionToDelete = nil
            showSectionOptions = nil
        }
    }
    
    private func renameSectionToRename() {
        guard let sectionToRename else {
            return
        }
        
        sectionToRename.rename(sectionRenameString)
        self.sectionToRename = nil
        self.sectionRenameString = ""
        showSectionOptions = nil
    }
    
    private func deleteExerciseGroups(_ offsets: IndexSet, in section: Workout.Section) {
        for offset in offsets {
            let group = section.groupedExercises[offset]
            deleteExerciseGroup(group)
        }
    }
    
    private func deleteExerciseGroup(_ group: ExerciseGroup) {
        for section in workout.sortedSections {
            section.removeAll(exercises: group.exercises)
        }
    }
    
    private func scrollToNewExerciseSection(_ proxy: ScrollViewProxy) {
        guard showNewExerciseControls else { return }
        
        withAnimation(.snappy) {
            proxy.scrollTo(newExerciseSectionId, anchor: .top)
        }
    }
    
    // This func keeps `date` up to date when opening the app. Basically,
    // if you open the app on a different day than you last closed it then `date` will be .today
    private func onChangeOf(scenePhase: ScenePhase) {
        switch scenePhase {
        case .active:
            if SimpleDate(rawValue: SimpleDate.RawValue(previouslyOpenedDateInt)) != .today {
                date = .today
            }
            break
        case .background:
            previouslyOpenedDateInt = Int(SimpleDate.today.rawValue)
        default:
            break
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                List {
                    WorkoutFocusSection()
                    ForEach(workout.sortedSections) { section in
                        WorkoutSection(section)
                    }
                    AddSectionToWorkoutButton()
                    if !showNewExerciseControls {
                        Spacer(minLength: 64)
                            .workoutExerciseRow()
                    }
                }
                .listDefaultModifiers()
                .scrollDismissesKeyboard(.automatic)
                .onAppear { scrollToNewExerciseSection(proxy) }
                .onChange(of: currentExercise) { scrollToNewExerciseSection(proxy) }
                .onChange(of: showNewExerciseControls) { scrollToNewExerciseSection(proxy) }
            }
            if let section = currentSection, !isWorkoutFocusInFocus, showNewExerciseControls {
                WorkoutViewNewExerciseSection(
                    workoutSectionId: section.id,
                    weightEditor: $weightEditor,
                    repsEditor: $repsEditor,
                    distanceEditor: $distanceEditor,
                    durationEditor: $durationEditor,
                    restEditor: $restEditor
                )
            }
        }
        .overlay(alignment: .bottomLeading) {
            PlayPauseWorkoutButton()
                .padding()
        }
        .animation(.snappy, value: isWorkoutFocusInFocus)
        .animation(.snappy, value: workout)
        .animation(.snappy, value: showSectionOptions)
        .animation(.snappy, value: showNewExerciseControls)
        .onChange(of: scenePhase) { old, new in onChangeOf(scenePhase: new) }
        .toolbar { Toolbar() }
        .toolbarTitleDisplayMode(.inline)
        .alert(
            "What do you want to name this workout section?",
            isPresented: $showAddSection
        ) {
            TextField(
                text: $newWorkoutSectionName,
                label: { Text("Warm-Up, Workout, etc...") }
            )
            Button("OK", action: addNewSectionToWorkout)
            Button("Cancel", role: .cancel) { }
        }
        .alert(
            "What do you want \"\(sectionToRename?.name ?? "")\" to be renamed to?",
            isPresented: .init(
                get: { sectionToRename != nil },
                set: { isPresented in sectionToRename = isPresented ? sectionToRename : nil }
            )
        ) {
            TextField(
                text: $sectionRenameString,
                label: { Text("Warm-Up, Workout, etc...") }
            )
            Button("OK", action: renameSectionToRename)
            Button("Cancel", role: .cancel) { }
        }
        .confirmationDialog(
            "Are you sure you want to remove the \"\(sectionToDelete?.name ?? "")\" section and all of its exercises?",
            isPresented: .init(
                get: { sectionToDelete != nil },
                set: { isPresented in sectionToDelete = isPresented ? sectionToDelete : nil }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete It!", role: .destructive, action: removeSectionFromWorkout)
            Button("Cancel", role: .cancel) { }
        }
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
            DateButton()
        }
    }
    
    @ViewBuilder private func PlayPauseWorkoutButton() -> some View {
        Button {
            showNewExerciseControls.toggle()
        } label: {
            Image(systemName: showNewExerciseControls ? "pause" : "play")
                .contentTransition(.symbolEffect(.replace, options: .speed(2)))
                .fabButton(diminished: showNewExerciseControls)
        }
        .disabled(hidePlayPauseWorkoutButton)
        .opacity(hidePlayPauseWorkoutButton ? 0 : 1)
    }
    
    @ViewBuilder private func DateButton() -> some View {
        HStack {
            DecrementDateButton()
            Button {
                
            } label: {
                Text(date.formatted())
                    .fieldButton()
            }
            .overlay{
                DatePicker(
                    "",
                    selection: .init(
                        get: { date.toDate() ?? .now },
                        set: { date = SimpleDate(date: $0)! }
                    ),
                    displayedComponents: [.date]
                )
                .blendMode(.destinationOver) //MARK: use this extension to keep the clickable functionality
            }
            .padding(.horizontal)
            IncrementDateButton()
        }
    }
    
    @ViewBuilder private func DecrementDateButton() -> some View {
        Button {
            date = date.adding(days: -1)
        } label: {
            Image(systemName: "chevron.backward")
                .toolbarCircleButton()
        }
    }
    
    @ViewBuilder private func IncrementDateButton() -> some View {
        Button {
            date = date.adding(days: 1)
        } label: {
            Image(systemName: "chevron.forward")
                .toolbarCircleButton()
        }
    }
    
    @ViewBuilder private func WorkoutFocusSection() -> some View {
        Section {
            VStack {
                TextField(
                    text: $workoutFocusString,
                    label: { Text(Workout.Focus.prompt.formatted()) }
                )
                .autocapitalization(.words)
                .focused($isWorkoutFocusInFocus)
                .submitLabel(.done)
                .fieldButton()
                
                let isTooLong = workoutFocusString.count > Workout.Focus.maxTextLength
                FieldCaption(
                    "\(isTooLong ? "Too long" : "") \(workoutFocusString.count)/\(Workout.Focus.maxTextLength)",
                    isError: isTooLong
                )
            }
            .workoutExerciseRow()
            .onChange(of: workoutFocusString) { _, newValue in
                workout.focus = .init(newValue)
            }
            .onChange(of: workout, initial: true) { _, newValue in
                workoutFocusString = newValue.focus?.formatted() ?? ""
            }
        } header: {
            SectionHeader("Focus")
        }
    }
    
    //TODO: Add ability to reorder exercises
    @ViewBuilder private func WorkoutSection(_ section: Workout.Section) -> some View {
        Section {
            ForEach(section.groupedExercises) { exerciseGroup in
                WorkoutViewExerciseRow(exerciseGroup, in: section)
                    .contextMenu {
                        Button(role: .destructive) {
                            deleteExerciseGroup(exerciseGroup)
                        } label: {
                            LabeledContent("Delete") { Image(systemName: "trash")}
                        }
                    }
            }
            .onDelete { deleteExerciseGroups($0, in: section) }
        } header: {
            HStack {
                Button {
                    showSectionOptions = showSectionOptions == section ? nil : section
                } label: {
                    SectionHeader(section.name)
                        .animation(.snappy, value: section.name)
                        .contentTransition(.numericText())
                }
                Spacer(minLength: 0)
                Menu {
                    Button("Rename", systemImage: "pencil") { sectionToRename = section }
                    Button("Delete", systemImage: "trash", role: .destructive) { sectionToDelete = section }
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.headline)
                        .foregroundStyle(Color.accent)
                }
                .textCase(.none)
                .opacity(showSectionOptions == section ? 1 : 0)
                .offset(x: showSectionOptions == section ? 0 : 50)
            }
        }
    }
    
    @ViewBuilder private func AddSectionToWorkoutButton() -> some View {
        Section {
            Button {
                showAddSection = true
            } label: {
                Text("Add Workout Section")
            }
            .foregroundStyle(Color.accent)
            .workoutSectionHeader()
            .workoutExerciseRow()
            .id(newExerciseSectionId)
        }
    }
}

#Preview {
    NavigationStack {
        WorkoutView()
            .modelContainer(for: Workout.self, inMemory: true)
            .foregroundStyle(Color.text)
            .background(Color.background)
    }
}
