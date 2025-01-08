//
//  WorkoutView_List.swift
//  Exercisely
//
//  Created by Jason Vance on 1/7/25.
//

import SwiftUI

struct WorkoutView_List: View {
    
    @State private var workoutFocus: String = ""
    @State private var date: Date = Date()
    
    private func onChangeOf(date: Date) {
        //TODO: Pull up the new date's data
    }
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 6) {
                    Text("YTW")
                    Text("1x5")
                }
                .workoutActivityRow()
                HStack(spacing: 6) {
                    Text("Archer Press")
                    Text("1x10")
                }
                .workoutActivityRow()
                HStack(spacing: 6) {
                    Text("TRX Chest Stretch")
                    Text("1x5")
                }
                .workoutActivityRow()
                .overlay(alignment: .bottomLeading) {
                    ZStack {
                        RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                            .stroke(style: .init(lineWidth: 1))
                            .frame(width: 18, height: 108)
                        Text("2x")
                            .font(.caption)
                    }
                }
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
                    .font(.headline)
                    .bold()
            }
            Section {
                HStack(spacing: 6) {
                    Text("Turkish Get-up")
                    Text("1x3")
                    Text("5lbs")
                }
                .workoutActivityRow()
                HStack(spacing: 6) {
                    Text("Shoulder Touches")
                    Text("1x10")
                }
                .workoutActivityRow()
                HStack(spacing: 6) {
                    Text("Kettlebell Shoulder Press")
                    Text("1x5")
                    Text("15lbs")
                }
                .workoutActivityRow()
                .overlay(alignment: .bottomLeading) {
                    ZStack {
                        RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                            .stroke(style: .init(lineWidth: 1))
                            .frame(width: 18, height: 108)
                        Text("3x")
                            .font(.caption)
                    }
                }
                HStack(spacing: 6) {
                    Text("Machine Shoulder Press")
                    Text("3x15")
                    Text("95lbs")
                }
                .workoutActivityRow()
                .overlay(alignment: .bottomLeading) {
                    ZStack {
                        RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                            .stroke(style: .init(lineWidth: 1))
                            .frame(width: 18, height: 18)
                        Text("3x")
                            .font(.caption)
                            .hidden()
                    }
                }
                HStack(spacing: 6) {
                    Text("Machine Underhand Row")
                    Text("3x15")
                    Text("95lbs")
                }
                .workoutActivityRow()
                .overlay(alignment: .bottomLeading) {
                    ZStack {
                        RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                            .stroke(style: .init(lineWidth: 1))
                            .frame(width: 18, height: 18)
                        Text("3x")
                            .font(.caption)
                            .hidden()
                    }
                }
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
                    .font(.headline)
                    .bold()
            }
            Section {
                HStack(spacing: 6) {
                    Text("Hike")
                    Text("15mins")
                }
                .workoutActivityRow()
                .overlay(alignment: .bottomLeading) {
                    ZStack {
                        RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                            .stroke(style: .init(lineWidth: 1))
                            .frame(width: 18, height: 18)
                        Text("3x")
                            .font(.caption)
                            .hidden()
                    }
                }
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
                    .font(.headline)
                    .bold()
            }
            Section {

            } header: {
                Button {
                    
                } label: {
                    Text("Add Workout Section")
                }
                .foregroundStyle(Color.accent)
                .font(.headline)
                .bold()
            }
        }
        .listStyle(.grouped)
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
            TextField(text: $workoutFocus, label: { Text(Workout.Focus.sample.value) })
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
}

#Preview {
    NavigationStack {
        WorkoutView_List()
            .modelContainer(for: Item.self, inMemory: true)
            .foregroundStyle(Color.text)
            .background(Color.background)
    }
}
