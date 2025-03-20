//
//  ExerciseGroupDetailView.swift
//  Exercisely
//
//  Created by Jason Vance on 3/16/25.
//

import SwiftUI
import SwiftData

//TODO: Fix deleting the first exercise will dismiss the view
// ^^ The exerciseId is based on the first workout, so it won't be
//  able to find the right exerciseGroup (see justDeletedTheLastExerciseInTheGroup)
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
    
    private var showExerciseName: Bool {
        switch exerciseGroup {
        case .superset: return true
        default: return false
        }
    }

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
        
        let justDeletedTheLastExerciseInTheGroup = workoutSection != nil && exerciseGroup == nil
        if justDeletedTheLastExerciseInTheGroup {
            presentation.wrappedValue.dismiss()
        }
    }
    
    init(for exerciseGroup: ExerciseGroup, in workoutSectionId: Workout.Section.ID) {
        self.exerciseId = exerciseGroup.id
        self.workoutSectionId = workoutSectionId
    }
    
    var body: some View {
        List {
            if let exerciseGroup = exerciseGroup  {
                ExerciseGroupSection(exerciseGroup)
                SetsSection(exerciseGroup)
            }
        }
        .listDefaultModifiers()
        .toolbar { Toolbar() }
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .animation(.snappy, value: exerciseGroup?.exercises)
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
    
    @ViewBuilder private func ExerciseGroupSection(_ exerciseGroup: ExerciseGroup) -> some View {
        if let workoutSection = workoutSection {
            WorkoutViewExerciseRow(exerciseGroup, in: workoutSection)
                .disabled(true)
        }
        Group {
            switch exerciseGroup {
            case .set:
                EmptyView()
            case .dropSet:
                Text("Note: Changing the weight of a set may remove the \"Drop Set\" classification")
            case .superset:
                Text("Note: Removing an exercise from a superset may remove the \"Superset\" classification.")
            }
        }
        .padding(.horizontal)
        .workoutExerciseRow()
        .font(.caption)
    }
    
    @ViewBuilder private func SetsSection(_ exerciseGroup: ExerciseGroup) -> some View {
            ForEach(exerciseGroup.exercises.indices, id: \.self) { index in
                var exercise = exerciseGroup.exercises[index]
                NavigationLinkNoChevron {
                    ExerciseDetailView(.init(get: { exercise }, set: { exercise = $0 }))
                } label: {
                    ExerciseRow(exercise, at: index)
                        .contextMenu {
                            Button(role: .destructive) {
                                deleteExercises([exercise])
                            } label: {
                                LabeledContent("Delete") { Image(systemName: "trash") }
                            }
                        }
                }
                .workoutExerciseRow()
            }
            .onDelete { deleteExercises($0, in: exerciseGroup)}
            if let lastExercise = exerciseGroup.exercises.last {
                AddExerciseRow(lastExercise)
            }
    }
    
    @ViewBuilder private func ExerciseRow(_ exercise: Workout.Exercise, at index: Int) -> some View {
        HStack {
            Image(systemName: "\(index + 1).circle")
            VStack {
                if showExerciseName {
                    HStack {
                        Text(exercise.name.formatted())
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 0)
                    }
                    .font(.headline)
                }
                ExerciseRowCommonMetrics([exercise])
            }
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
    let section = Workout.Section.sampleWorkout
    
    NavigationStack {
        ExerciseGroupDetailView(
            for: section.groupedExercises[0],
            in: section.id
        )
    }
    .modelContainer(for: Workout.self, inMemory: true) { result in
        switch result {
        case .success(let modelContainer):
            let context = modelContainer.mainContext
            context.insert(section)
        case .failure(let error):
            print("Error: \(error)")
        }
    }
}
