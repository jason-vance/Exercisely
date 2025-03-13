//
//  WorkoutView.swift
//  Exercisely
//
//  Created by Jason Vance on 1/7/25.
//

import SwiftUI

struct WorkoutView: View {
    
    @State private var workoutFocusString: String = ""
    @State private var date: SimpleDate = .today
    @State private var workout: Workout = .sample
    
    private func onChangeOf(date: SimpleDate) {
        //TODO: Pull up the new date's data
    }
    
    var body: some View {
        List {
            ForEach(workout.sections) { section in
                WorkoutSection(section)
            }
            AddWorkoutSection()
        }
        .listDefaultModifiers()
        .toolbar { Toolbar() }
    }
    
    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            WorkoutCategoryField()
        }
        ToolbarItem(placement: .topBarTrailing) {
            DateButton()
        }
    }
    
    @ViewBuilder private func WorkoutCategoryField() -> some View {
        HStack {
            Text("Focus:")
                .foregroundStyle(Color.text)
                .bold()
            TextField(text: $workoutFocusString, label: { Text(Workout.Focus.prompt.formatted()) })
                .foregroundStyle(Color.text)
                .bold()
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(Color.accentColor)
                }
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
    
    @ViewBuilder private func ExerciseReps(_ reps: Int) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "arrow.triangle.2.circlepath")
            Text("\(reps)reps")
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
    
    @ViewBuilder private func ExerciseDistance(_ distance: Double) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "point.bottomleft.forward.to.arrow.triangle.scurvepath")
            //TODO: Get formatted value from Workout.Exercise.Distance
            Text("\(distance.formatted())mi")
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func ExerciseTime(_ time: TimeInterval) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "timer")
            //TODO: Get formatted value from Workout.Exercise.Time
            Text("\(time.formatted())secs")
        }
        .workoutExerciseDataItem()
    }
    
    @ViewBuilder private func AddWorkoutSection() -> some View {
        Section {
        } header: {
            Button {
                
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
