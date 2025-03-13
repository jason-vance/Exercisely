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
    
    @State private var workoutFocusString: String = ""
    @State private var date: SimpleDate = .today
    @Query private var workouts: [Workout]
    
    var workout: Workout? {
        if let workout = workouts.first(where: { $0.date == date }) {
            return workout
        }
        
        modelContext.insert(Workout(date: date))
        return nil
    }

    private func onChangeOf(date: SimpleDate) {
        //TODO: Pull up the new date's data
    }
    
    var body: some View {
        List {
            if let workout = workout {
                WorkoutFocusSection()
                ForEach(workout.sections) { section in
                    WorkoutSection(section)
                }
                AddSectionToWorkoutButton()
            }
        }
        .listDefaultModifiers()
        .toolbar { Toolbar() }
        .toolbarTitleDisplayMode(.inline)
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
                axis: .vertical,
                label: { Text(Workout.Focus.prompt.formatted()) }
            )
            .bold()
            .workoutExerciseRow()
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.accentColor)
            }
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
                .foregroundStyle(Color.text)
                .bold()
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(Color.accentColor)
                }
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
            .onChange(of: date) { _, date in
                onChangeOf(date: date)
            }
        }
    }
    
    @ViewBuilder private func WorkoutSection(_ section: Workout.Section) -> some View {
        Section {
            ForEach(Workout.Exercise.group(exercises: section.exercises)) { exercise in
                GroupedExercise(exercise)
            }
        } header: {
            SectionHeader(section.name)
        } footer: {
            AddExerciseButton(section)
        }
    }
    
    @ViewBuilder private func SectionHeader(_ text: String) -> some View {
        HStack(spacing: 0) {
            Text(text)
            Text(":")
            Spacer(minLength: 0)
        }
        .workoutSectionHeader()
    }
    
    @ViewBuilder private func AddExerciseButton(_ section: Workout.Section) -> some View {
        Button {
            //TODO: Implement AddExerciseButton function
        } label: {
            HStack {
                Image(systemName: "plus.circle")
                Text("Add Exercise")
                Spacer(minLength: 0)
            }
        }
        .font(.headline)
        .foregroundStyle(Color.accent)
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
                    if let time = exercise.time {
                        ExerciseTime(time)
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
    
    @ViewBuilder private func ExerciseTime(_ time: Workout.Exercise.Duration) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "timer")
            Text("\(time.formatted())")
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func AddSectionToWorkoutButton() -> some View {
        Section {
        } header: {
            Button {
                //TODO: Implement AddSectionToWorkoutButton function
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
            .modelContainer(for: Item.self, inMemory: true)
            .foregroundStyle(Color.text)
            .background(Color.background)
    }
}
