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
            ForEach(Workout.Activity.group(activities: section.activities)) { activity in
                GroupedWorkoutActivity(activity)
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
    
    @ViewBuilder private func GroupedWorkoutActivity(_ workoutActivityGroup: WorkoutActivityGroup) -> some View {
        switch workoutActivityGroup {
        case .single(let activity):
            SingleWorkoutActivity(activity)
        case .set(let activities):
            SetWorkoutActivity(activities)
        }
    }
    
    @ViewBuilder private func SingleWorkoutActivity(_ activity: Workout.Activity) -> some View {
        SetWorkoutActivity([activity])
    }
    
    @ViewBuilder private func SetWorkoutActivity(_ activities: [Workout.Activity]) -> some View {
        if let activity = activities.first {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: .activityRowBulletSize, height: .activityRowBulletSize)
                    Text(activity.exercise.formatted())
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 0)
                }
                .font(.headline)
                HStack {
                    let sets = activities.count
                    if sets > 1 {
                        ActivitySets(sets)
                    }
                    if let reps = activity.reps {
                        ActivityReps(reps)
                    }
                    if let weight = activity.weight {
                        ActivityWeight(weight)
                    }
                    if let distance = activity.distance {
                        ActivityDistance(distance)
                    }
                    if let time = activity.time {
                        ActivityTime(time)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.leading, 12)
            }
            .workoutActivityRow()
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder private func ActivitySets(_ sets: Int) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "square.stack.3d.up")
            Text("\(sets)sets")
        }
        .workoutActivityDataItem()
    }
    
    @ViewBuilder private func ActivityReps(_ reps: Int) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "arrow.triangle.2.circlepath")
            Text("\(reps)reps")
        }
        .workoutActivityDataItem()
    }
    
    @ViewBuilder private func ActivityWeight(_ weight: Double) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "dumbbell")
            //TODO: Get formatted value from Workout.Activity.Weight
            Text("\(weight.formatted())lbs")
        }
        .workoutActivityDataItem()
    }
    
    @ViewBuilder private func ActivityDistance(_ distance: Double) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "point.bottomleft.forward.to.arrow.triangle.scurvepath")
            //TODO: Get formatted value from Workout.Activity.Distance
            Text("\(distance.formatted())mi")
        }
        .workoutActivityDataItem()
    }
    
    @ViewBuilder private func ActivityTime(_ time: TimeInterval) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "timer")
            //TODO: Get formatted value from Workout.Activity.Time
            Text("\(time.formatted())secs")
        }
        .workoutActivityDataItem()
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
