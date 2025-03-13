//
//  WorkoutView_List.swift
//  Exercisely
//
//  Created by Jason Vance on 1/7/25.
//

import SwiftUI

struct WorkoutView_List: View {
    
    @State private var workoutFocusString: String = ""
    @State private var date: Date = Date()
    
    private func onChangeOf(date: Date) {
        //TODO: Pull up the new date's data
    }
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 6) {
                    Text("YTW")
                    Text("-")
                    Text("5reps")
                }
                .workoutActivityRow()
                HStack(spacing: 6) {
                    Text("Archer Press")
                    Text("-")
                    Text("10reps")
                }
                .workoutActivityRow()
                HStack(spacing: 6) {
                    Text("TRX Chest Stretch")
                    Text("-")
                    Text("5reps")
                }
                .workoutActivityRow()
                .workoutSetsCountOverlay(setsCount: 2, exerciseCount: 3)
                Button {

                } label: {
                    HStack {
                        Text("Add Activity")
                    }
                }
                .workoutActivityRow()
                .overlay(alignment: .bottomLeading) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 18, height: 18)
                }
                .foregroundStyle(Color.accent)
            } header: {
                Text("Warm-up:")
                    .workoutSectionHeader()
            }
            Section {
                HStack(spacing: 6) {
                    Text("Turkish Get-up")
                    Text("-")
                    Text("3reps")
                    Text("5lbs")
                }
                .workoutActivityRow()
                HStack(spacing: 6) {
                    Text("Shoulder Touches")
                    Text("-")
                    Text("10reps")
                }
                .workoutActivityRow()
                HStack(spacing: 6) {
                    Text("Kettlebell Shoulder Press")
                    Text("-")
                    Text("5reps")
                    Text("15lbs")
                }
                .workoutActivityRow()
                .workoutSetsCountOverlay(setsCount: 3, exerciseCount: 3)
                HStack(spacing: 6) {
                    Text("Machine Shoulder Press")
                    Text("-")
                    Text("15reps")
                    Text("95lbs")
                }
                .workoutActivityRow()
                .workoutSetsCountOverlay(setsCount: 3, exerciseCount: 1)
                HStack(spacing: 6) {
                    Text("Machine Underhand Row")
                    Text("-")
                    Text("15reps")
                    Text("95lbs")
                }
                .workoutActivityRow()
                .workoutSetsCountOverlay(setsCount: 3, exerciseCount: 1)
                Button {
                    
                } label: {
                    HStack {
                        Text("Add Activity")
                    }
                }
                .workoutActivityRow()
                .overlay(alignment: .bottomLeading) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 18, height: 18)
                }
                .foregroundStyle(Color.accent)
            } header: {
                Text("Workout:")
                    .workoutSectionHeader()
            }
            Section {
                HStack(spacing: 6) {
                    Text("Hike")
                    Text("-")
                    Text("15mins")
                }
                .workoutActivityRow()
                .workoutSetsCountOverlay(setsCount: 1, exerciseCount: 1)
                Button {
                    
                } label: {
                    HStack {
                        Text("Add Activity")
                    }
                }
                .workoutActivityRow()
                .overlay(alignment: .bottomLeading) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 18, height: 18)
                }
                .foregroundStyle(Color.accent)
            } header: {
                Text("Cooldown:")
                    .workoutSectionHeader()
            }
            AddWorkoutSection()
        }
        .listStyle(.grouped)
        .toolbar { Toolbar() }
    }
    
    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
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
            Text(date.toBasicUiString())
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
                selection: $date,
                displayedComponents: [.date]
            )
            .blendMode(.destinationOver) //MARK: use this extension to keep the clickable functionality
            .onChange(of: date) { _, date in
                onChangeOf(date: date)
            }
        }
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
        WorkoutView_List()
            .modelContainer(for: Item.self, inMemory: true)
            .foregroundStyle(Color.text)
            .background(Color.background)
    }
}
