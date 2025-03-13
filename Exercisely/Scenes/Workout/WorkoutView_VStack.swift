//
//  WorkoutView_VStack.swift
//  Exercisely
//
//  Created by Jason Vance on 1/8/25.
//

import SwiftUI

struct WorkoutView_VStack: View {
    
    @State private var workoutFocus: String = ""
    @State private var date: Date = Date()
    @State private var workout: Workout = .sample
    
    private func onChangeOf(date: Date) {
        //TODO: Pull up the new date's data
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(workout.sections) { section in
                    WorkoutSection(section)
                }
            }
        }
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
            TextField(text: $workoutFocus, label: { Text(Workout.Focus.prompt.formatted()) })
                .foregroundStyle(Color.text)
                .bold()
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .frame(height: .textFieldUnderlineHeight)
                        .foregroundStyle(Color.accentColor)
                }
        }
    }
    
    @ViewBuilder private func DateButton() -> some View {
        Button {
            
        } label: {
            Text(workout.date.toBasicUiString())
                .foregroundStyle(Color.text)
                .bold()
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .frame(height: .textFieldUnderlineHeight)
                        .foregroundStyle(Color.accentColor)
                }
        }
        .overlay{
            DatePicker(
                "",
                selection: $date,
                displayedComponents: [.date]
            )
            .blendMode(.destinationOver) //MARK: use this extension to keep the clickable functionality
            .onChange(of: date) { _, date in
                onChangeOf(date: date)
            }
        }
    }
    
    @ViewBuilder private func WorkoutSection(_ section: Workout.Section) -> some View {
        VStack(spacing: 0) {
            SectionHeader(section.name)
            ForEach(section.activities) { activity in
                SingleWorkoutActivity(activity)
            }
            AddActivityButton(section)
        }
    }
    
    @ViewBuilder private func SectionHeader(_ text: String) -> some View {
        HStack(spacing: 0) {
            Text(text)
            Text(":")
            Spacer(minLength: 0)
        }
        .font(.headline)
        .bold()
        .multilineTextAlignment(.leading)
        .frame(height: .activityRowHeight)
        .padding(.leading, .padding)
    }
    
    @ViewBuilder private func AddActivityButton(_ section: Workout.Section) -> some View {
        Button {

        } label: {
            HStack {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: .activityRowCircleSize, height: .activityRowCircleSize)
                Text("Add Activity")
                Spacer(minLength: 0)
            }
        }
        .foregroundStyle(Color.accent)
        .frame(height: .activityRowHeight)
        .padding(.leading, .activityRowLeadingPadding)
    }
    
    @ViewBuilder private func SingleWorkoutActivity(_ activity: Workout.Activity) -> some View {
        HStack {
            Image(systemName: "circle")
                .resizable()
                .frame(width: .activityRowCircleSize, height: .activityRowCircleSize)
            if let reps = activity.reps {
                Text("\(reps)")
            }
            Text(activity.exercise.formatted())
                .multilineTextAlignment(.leading)
            if let weight = activity.weight {
                Text("\(weight.formatted())lbs")
            }
            if let distance = activity.distance {
                //TODO: Get formatted value from Workout.Activity.Distance
                Text("\(distance.formatted())mi")
            }
            if let time = activity.time {
                //TODO: Get formatted value from Workout.Activity.Time
                Text("\(time.formatted())secs")
            }
            Spacer(minLength: 0)
        }
        .foregroundStyle(Color.text)
        .frame(height: .activityRowHeight)
        .padding(.leading, .activityRowLeadingPadding)
    }
}

#Preview {
    NavigationStack {
        WorkoutView_VStack()
            .modelContainer(for: Item.self, inMemory: true)
            .foregroundStyle(Color.text)
            .background(Color.background)
    }
}
