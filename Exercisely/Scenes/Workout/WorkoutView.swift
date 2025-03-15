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
    
    @State private var sectionToAddExercise: Workout.Section? = nil
    
    var workout: Workout? {
        if let workout = workouts.first(where: { $0.date == date }) {
            return workout
        }
        
        modelContext.insert(Workout(date: date))
        return nil
    }
    
    private func addNewSectionToWorkout() {
        let order = workout?.sections.max(by: { $0.order > $1.order })?.order ?? 0
        workout?.append(section: .init(name: newWorkoutSectionName, order: order))
        showAddSection = false
        newWorkoutSectionName = ""
    }
    
    private func removeSectionFromWorkout() {
        guard let sectionToDelete = sectionToDelete else { return }
        workout?.sections.removeAll(where: { $0.id == sectionToDelete.id })
        self.sectionToDelete = nil
        showSectionOptions = nil
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
                ForEach(workout.sections.sorted(by: { $0.order < $1.order })) { section in
                    WorkoutSection(section)
                }
                AddSectionToWorkoutButton()
            }
        }
        .listDefaultModifiers()
        .animation(.snappy, value: workout)
        .animation(.snappy, value: workout?.sections)
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
            ForEach(Workout.Exercise.group(exercises: section.exercises)) { exercise in
                GroupedExercise(exercise)
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
            AddExerciseButton(section)
        }
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
    
    @ViewBuilder private func GroupedExercise(_ exerciseGroup: ExerciseGroup) -> some View {
        switch exerciseGroup {
        case .single(let exercise):
            SingleExercise(exercise)
        case .set(let exercises):
            SetExercise(exercises)
        }
    }
    
    @ViewBuilder private func SingleExercise(_ exercise: Workout.Exercise) -> some View {
        SetExercise([exercise])
    }
    
    @ViewBuilder private func SetExercise(_ exercises: [Workout.Exercise]) -> some View {
        if let exercise = exercises.first {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: .activityRowBulletSize, height: .activityRowBulletSize)
                    Text(exercise.name.formatted())
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 0)
                }
                .font(.headline)
                HStack {
                    let sets = exercises.count
                    if sets > 1 {
                        ExerciseSets(sets)
                    }
                    if let reps = exercise.reps {
                        ExerciseReps(reps)
                    }
                    if let weight = exercise.weight {
                        ExerciseWeight(weight)
                    }
                    if let distance = exercise.distance {
                        ExerciseDistance(distance)
                    }
                    if let duration = exercise.duration {
                        ExerciseDuration(duration)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.leading, 12)
            }
            .workoutExerciseRow()
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder private func ExerciseSets(_ sets: Int) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "square.stack.3d.up")
            Text("\(sets)sets")
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func ExerciseReps(_ reps: Workout.Exercise.Reps) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "arrow.triangle.2.circlepath")
            Text("\(reps.formatted())")
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func ExerciseWeight(_ weight: Weight) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "dumbbell")
            Text("\(weight.formatted())")
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func ExerciseDistance(_ distance: Distance) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "point.bottomleft.forward.to.arrow.triangle.scurvepath")
            Text("\(distance.formatted())")
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func ExerciseDuration(_ duration: Workout.Exercise.Duration) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "timer")
            Text("\(duration.formatted())")
        }
        .workoutExerciseDataItem()
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
