//
//  ExerciseGroupDetailView.swift
//  Exercisely
//
//  Created by Jason Vance on 3/16/25.
//

import SwiftUI
import SwiftData

//TODO: MVP: Add ability to edit exercises in an ExerciseGroup
struct ExerciseGroupDetailView: View {
    
    @Environment(\.presentationMode) var presentation
    
    private let workoutSectionId: Workout.Section.ID
    private let exerciseId: Workout.Exercise.ID
    
    @Query private var workoutSections: [Workout.Section]
    private var workoutSection: Workout.Section? {
        let rv = workoutSections.first(where: { $0.id == workoutSectionId })
        return rv
    }
    
    private var exerciseGroup: ExerciseGroup? {
        workoutSection?.groupedExercises.first(where: { $0.contains(exerciseId) })
    }
    
    // .navigationDestination cannot be inside of a lazy container.
    // So, I have to use these props to let ExerciseSetQuickAddControls
    // reach back outside to the List in this view.
    @State private var weightEditor: Binding<Weight?>? = nil
    @State private var repsEditor: Binding<Workout.Exercise.Reps?>? = nil
    @State private var distanceEditor: Binding<Distance?>? = nil
    @State private var durationEditor: Binding<Workout.Exercise.Duration?>? = nil
    @State private var restEditor: Binding<Workout.Exercise.Duration?>? = nil

    @State private var showDeleteConfirmation: Bool = false
    
    private func deleteExerciseGroup() {
        if let workoutSection = workoutSection, let exerciseGroup = exerciseGroup {
            workoutSection.removeAll(exercises: exerciseGroup.exercises)
            presentation.wrappedValue.dismiss()
        }
    }
    
    private func addSet(copying exercise: Workout.Exercise) {
        if let newSet = Workout.Exercise(
            name: exercise.name,
            weight: exercise.weight,
            reps: exercise.reps,
            distance: exercise.distance,
            duration: exercise.duration,
            rest: exercise.rest
        ) {
            workoutSection?.insert(exercise: newSet, after: exercise)
        } else {
            print("Couldn't create new exercise")
        }
    }
    
    private func deleteExercises(_ offsets: IndexSet, in exerciseGroup: ExerciseGroup) {
        var exercises: [Workout.Exercise] = []
        for offset in offsets {
            exercises += [exerciseGroup.exercises[offset]]
        }
        
        deleteExercises(exercises)
    }
    
    private func deleteExercises(_ exercises: [Workout.Exercise]) {
        workoutSection?.removeAll(exercises: exercises)
    }
    
    init(for exerciseGroup: ExerciseGroup, in workoutSectionId: Workout.Section.ID) {
        self.exerciseId = exerciseGroup.id
        self.workoutSectionId = workoutSectionId
    }
    
    var body: some View {
        List {
            if let exerciseGroup = exerciseGroup  {
                if let workoutSection = workoutSection {
                    WorkoutViewExerciseRow(exerciseGroup, in: workoutSection)
                        .disabled(true)
                }
                ForEach(exerciseGroup.exercises.indices, id: \.self) { index in
                    let exercise = exerciseGroup.exercises[index]
                    ExerciseRow(exercise, at: index)
                        .contextMenu {
                            Button(role: .destructive) {
                                deleteExercises([exercise])
                            } label: {
                                LabeledContent("Delete") { Image(systemName: "trash") }
                            }
                        }
                }
                .onDelete { deleteExercises($0, in: exerciseGroup)}
                if let lastExercise = exerciseGroup.exercises.last {
                    AddExerciseRow(lastExercise)
                }
            }
        }
        .listDefaultModifiers()
        .toolbar { Toolbar() }
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .animation(.snappy, value: exerciseGroup?.exercises)
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
            ), mode: .duration)
        }
        .confirmationDialog(
            "Are you sure you want to delete this exercise?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible) {
                Button("Delete It!", role: .destructive, action: deleteExerciseGroup)
                Button("Cancel", role: .cancel) { }
            }
    }
    
    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(exerciseGroup?.name ?? "Exercise Detail")
                .bold(true)
                .foregroundStyle(Color.text)
        }
        ToolbarItem(placement: .topBarLeading) {
            BackButton()
        }
        ToolbarItem(placement: .topBarTrailing) {
            MenuButton()
        }
    }
    
    @ViewBuilder private func BackButton() -> some View {
        Button {
            presentation.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundStyle(Color.accentColor)
        }
    }
    
    @ViewBuilder private func MenuButton() -> some View {
        Menu {
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                LabeledContent("Delete") { Image(systemName: "trash")}
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.accentColor)
        }
    }
    
    @ViewBuilder private func ExerciseRow(_ exercise: Workout.Exercise, at index: Int) -> some View {
        HStack {
            Image(systemName: "\(index + 1).circle")
            ExerciseRowCommonMetrics([exercise])
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func AddExerciseRow(_ exercise: Workout.Exercise) -> some View {
        Button {
            addSet(copying: exercise)
        } label: {
            HStack {
                Image(systemName: "plus.circle")
                    .foregroundStyle(Color.accentColor)
                ExerciseRowCommonMetrics([exercise])
            }
        }
        .workoutExerciseRow()
    }
}

#Preview {
    NavigationStack {
        ExerciseGroupDetailView(
            for: Workout.Section.sampleWorkout.groupedExercises[0],
            in: Workout.Section.sampleWorkout.id
        )
    }
    .modelContainer(for: Workout.self, inMemory: true) { result in
        switch result {
        case .success(let modelContainer):
            let context = modelContainer.mainContext
            context.insert(Workout.Section.sampleWorkout)
        case .failure(let error):
            print("Error: \(error)")
        }
    }
}
