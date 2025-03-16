//
//  WorkoutView.swift
//  Exercisely
//
//  Created by Jason Vance on 1/7/25.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var workouts: [Workout]
    
    @State private var workoutFocusString: String = ""
    @State private var date: SimpleDate = .today
    
    @State private var showSectionOptions: Workout.Section? = nil
    @State private var sectionToDelete: Workout.Section? = nil
    @State private var sectionToRename: Workout.Section? = nil
    @State private var sectionRenameString: String = ""

    @State private var showAddSection: Bool = false
    @State private var newWorkoutSectionName: String = ""
    
    // .navigationDestination cannot be inside of a lazy container.
    // So, I have to use these props to let ExerciseSetQuickAddControls
    // reach back outside to the List in this view.
    @State private var weightEditor: Binding<Weight?>? = nil
    @State private var repsEditor: Binding<Workout.Exercise.Reps?>? = nil
    @State private var distanceEditor: Binding<Distance?>? = nil
    @State private var durationEditor: Binding<Workout.Exercise.Duration?>? = nil

    @State private var sectionToAddExercise: Workout.Section? = nil
    
    var workout: Workout? {
        if let workout = workouts.first(where: { $0.date == date }) {
            return workout
        }
        
        modelContext.insert(Workout(date: date))
        return nil
    }
    
    var currentSection: Workout.Section? {
        workout?.sortedSections.last
    }
    
    var currentExercise: Workout.Exercise? {
        currentSection?.sortedExercises.last
    }
    
    private func addNewSectionToWorkout() {
        withAnimation(.snappy) {
            workout?.append(section: .init(name: newWorkoutSectionName))
            showAddSection = false
            newWorkoutSectionName = ""
        }
    }
    
    private func removeSectionFromWorkout() {
        withAnimation(.snappy) {
            guard let sectionToDelete = sectionToDelete else { return }
            workout?.remove(section: sectionToDelete)
            self.sectionToDelete = nil
            showSectionOptions = nil
        }
    }
    
    private func renameSectionToRename() {
        sectionToRename?.name = sectionRenameString
        self.sectionToRename = nil
        self.sectionRenameString = ""
        showSectionOptions = nil
    }
    
    var body: some View {
        List {
            if let workout = workout {
                WorkoutFocusSection()
                ForEach(workout.sortedSections) { section in
                    WorkoutSection(section)
                }
                AddSectionToWorkoutButton()
            }
        }
        .listDefaultModifiers()
        .animation(.snappy, value: workout)
        .animation(.snappy, value: showSectionOptions)
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
        .navigationDestination(
            isPresented: .init(
                get: { weightEditor != nil },
                set: { isPresented in weightEditor = isPresented ? weightEditor : nil }
            )
        ) {
            ExerciseWeightEditView(weight: .init(
                get: { weightEditor?.wrappedValue },
                set: { weightEditor?.wrappedValue = $0 }
            ))
        }
        .navigationDestination(
            isPresented: .init(
                get: { repsEditor != nil },
                set: { isPresented in repsEditor = isPresented ? repsEditor : nil }
            )
        ) {
            ExerciseRepsEditView(reps: .init(
                get: { repsEditor?.wrappedValue },
                set: { repsEditor?.wrappedValue = $0 }
            ))
        }
        .navigationDestination(
            isPresented: .init(
                get: { distanceEditor != nil },
                set: { isPresented in distanceEditor = isPresented ? distanceEditor : nil }
            )
        ) {
            ExerciseDistanceEditView(distance: .init(
                get: { distanceEditor?.wrappedValue },
                set: { distanceEditor?.wrappedValue = $0 }
            ))
        }
        .navigationDestination(
            isPresented: .init(
                get: { durationEditor != nil },
                set: { isPresented in durationEditor = isPresented ? durationEditor : nil }
            )
        ) {
            ExerciseDurationEditView(duration: .init(
                get: { durationEditor?.wrappedValue },
                set: { durationEditor?.wrappedValue = $0 }
            ))
        }
    }
    
    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            DateButton()
        }
    }
    
    //TODO: warn the user if their focus is too long
    @ViewBuilder private func WorkoutFocusSection() -> some View {
        Section {
            TextField(
                text: $workoutFocusString,
                label: { Text(Workout.Focus.prompt.formatted()) }
            )
            .submitLabel(.done)
            .fieldButton()
            .workoutExerciseRow()
            .onChange(of: workoutFocusString) { _, newValue in
                if let workout = workout {
                    workout.focus = .init(newValue)
                }
            }
            .onChange(of: workout, initial: true) { _, newValue in
                workoutFocusString = newValue?.focus?.formatted() ?? ""
            }
        } header: {
            SectionHeader("Focus")
        }
    }
    
    @ViewBuilder private func DateButton() -> some View {
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
    }
    
    @ViewBuilder private func WorkoutSection(_ section: Workout.Section) -> some View {
        Section {
            ForEach(Workout.Exercise.group(exercises: section.sortedExercises)) { exerciseGroup in
                WorkoutViewExerciseRow(exerciseGroup, in: section)
                if let currentExercise, exerciseGroup.contains(currentExercise) {
                    ExerciseSetQuickAddControls(for: currentExercise, in: section)
                }
            }
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
        } footer: {
            if currentSection == section {
                AddExerciseButton(section)
            }
        }
    }
    
    @ViewBuilder private func ExerciseSetQuickAddControls(
        for currentExercise: Workout.Exercise,
        in section: Workout.Section
    ) -> some View {
        Exercisely.ExerciseSetQuickAddControls(
            for: currentExercise,
            in: section,
            weightEditor: $weightEditor,
            repsEditor: $repsEditor,
            distanceEditor: $distanceEditor,
            durationEditor: $durationEditor
        )
    }
    
    @ViewBuilder private func AddExerciseButton(_ section: Workout.Section) -> some View {
        NavigationLink {
            AddExerciseView(workoutSection: section)
        } label: {
            HStack {
                Image(systemName: "plus.circle")
                Text("Add Exercise")
                Spacer(minLength: 0)
            }
            .font(.headline)
            .foregroundStyle(Color.accent)
        }
    }
    
    @ViewBuilder private func AddSectionToWorkoutButton() -> some View {
        Section {
        } header: {
            Button {
                showAddSection = true
            } label: {
                Text("Add Workout Section")
            }
            .foregroundStyle(Color.accent)
            .workoutSectionHeader()
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
