//
//  ExerciseProgressView.swift
//  Exercisely
//
//  Created by Jason Vance on 4/3/25.
//

import SwiftUI
import SwiftData

//TODO: Release: Chart metrics over time
//TODO: Release: Show relevant data (PBs, growth rate, etc)
//TODO: Chart projected future progress
struct ExerciseProgressView: View {
    
    @State private var exerciseName: Workout.Exercise.Name? = nil
    
    @Query private var workouts: [Workout]
    
    private var exerciseGroups: [ExerciseGroup] {
        guard let exerciseName else {
            return []
        }
        
        return workouts
            .reduce(into: []) { groups, workout in
                groups.append(contentsOf: workout.getExerciseGroups(named: exerciseName))
            }
            .sorted { $0.exercises.first?.date ?? .today > $1.exercises.first?.date ?? .today }
    }

    var body: some View {
        List {
            ExerciseNameField()
            StatsSection()
            ExerciseGroupsSection()
        }
        .listDefaultModifiers()
        .toolbar { Toolbar() }
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .animation(.snappy, value: exerciseName)
        .foregroundStyle(Color.text)
        .background(Color.background)
    }
    
    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Exercise Progress")
                .navigationBarTitle()
        }
    }
    
    @ViewBuilder private func ExerciseNameField() -> some View {
        NavigationLinkNoChevron {
            ExerciseNameEditView(name: $exerciseName)
        } label: {
            HStack {
                Text(exerciseName?.formatted() ?? "Choose an exercise to view...")
                    .opacity(exerciseName == nil ? 0.35 : 1)
                    .fieldButton()
                    .underlined()
                Spacer()
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func StatsSection() -> some View {
        if !exerciseGroups.isEmpty {
            Section {
                PersonalBestWeightRow()
            } header: {
                Text("Stats")
                    .librarySectionHeader()
            }
        }
    }
    
    @ViewBuilder private func PersonalBestWeightRow() -> some View {
        let best = exerciseGroups
            .reduce(into: []) { exercises, group in
                exercises.append(contentsOf: group.exercises)
            }
            .compactMap { $0.weight }
            .max()
        
        
        if let best = best {
            HStack {
                Text("Weight PB:")
                    .fieldLabel()
                Spacer()
                Text(best.formatted())
                    .bold()
            }
            .workoutExerciseRow()
        }
    }
    
    @ViewBuilder private func ExerciseGroupsSection() -> some View {
        if !exerciseGroups.isEmpty {
            Section {
                ForEach(exerciseGroups, id: \.id) { group in
                    ExerciseProgressExerciseGroupRow(group)
                }
            } header: {
                Text("Exercise Groups")
                    .librarySectionHeader()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseProgressView()
    }
}
