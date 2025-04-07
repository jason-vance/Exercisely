//
//  ExerciseProgressView.swift
//  Exercisely
//
//  Created by Jason Vance on 4/3/25.
//

import SwiftUI
import SwiftData

//TODO: Show relevant data (sets, growth rate, etc)
//TODO: Chart projected future progress
struct ExerciseProgressView: View {
    
    //TODO: Add some kind of computed "effort" value
    enum ChartedMetric: String, CaseIterable {
        case weight = "Weight"
        case reps = "Reps"
        case distance = "Distance"
        case duration = "Duration"
    }
    
    @StateObject private var userSettings = UserSettings()

    @State private var exerciseName: Workout.Exercise.Name? = nil
    @State private var selectedMetric: ChartedMetric = .weight
    
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
    
    private var hasWeight: Bool {
        guard !exerciseGroups.isEmpty else {
            return false
        }
        
        return exerciseGroups.first { group in
            group.exercises.first { exercise in
                exercise.weight != nil
            } != nil
        } != nil
    }
    
    private var hasReps: Bool {
        guard !exerciseGroups.isEmpty else {
            return false
        }
        
        return exerciseGroups.first { group in
            group.exercises.first { exercise in
                exercise.reps != nil
            } != nil
        } != nil
    }
    
    private var hasDistance: Bool {
        guard !exerciseGroups.isEmpty else {
            return false
        }
        
        return exerciseGroups.first { group in
            group.exercises.first { exercise in
                exercise.distance != nil
            } != nil
        } != nil
    }
    
    private var hasDuration: Bool {
        guard !exerciseGroups.isEmpty else {
            return false
        }
        
        return exerciseGroups.first { group in
            group.exercises.first { exercise in
                exercise.duration != nil
            } != nil
        } != nil
    }

    var body: some View {
        let exerciseGroups = exerciseGroups
        
        List {
            ExerciseNameField()
            ChartSection(exerciseGroups: exerciseGroups)
            PersonalBestsSection(exerciseGroups: exerciseGroups)
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
    
    @ViewBuilder private func ChartSection(exerciseGroups: [ExerciseGroup]) -> some View {
        if !exerciseGroups.isEmpty {
            Section {
                TheChart()
                ChartMenu()
            }
        }
    }
    
    @ViewBuilder private func TheChart() -> some View {
        let values = exerciseGroups
            .map { group in
                ExerciseMetricChart.Value(
                    date: group.exercises.first?.workoutSection?.workout?.date ?? .today,
                    values: group.exercises.compactMap {
                        //TODO: Only convert these if necessary
                        switch selectedMetric {
                        case .weight:
                            return $0.weight?.convert(to: userSettings.defaultWeightUnit).value
                        case .reps:
                            guard let reps = $0.reps else { return nil }
                            return Double(reps.count)
                        case .distance:
                            return $0.distance?.convert(to: userSettings.defaultDistanceUnit)?.value
                        case .duration:
                            return $0.duration?.convert(to: userSettings.defaultDurationUnit)?.value
                        }
                    }
                )
            }
        
        ExerciseMetricChart(
            values: values,
            leftAxisFormatter: { value in
                switch selectedMetric {
                case .weight:
                    return Weight(value: value, unit: userSettings.defaultWeightUnit).formatted()
                case .reps:
                    return Workout.Exercise.Reps(Int(value))?.formatted() ?? value.formatted()
                case .distance:
                    return Distance(value: value, unit: userSettings.defaultDistanceUnit)?.formatted() ?? value.formatted()
                case .duration:
                    return Workout.Exercise.Duration(value: value, unit: userSettings.defaultDurationUnit)?.formatted() ?? value.formatted()
                }
            }
        )
        .frame(height: 250)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func ChartMenu() -> some View {
        HStack {
            Spacer()
            Menu {
                if hasWeight {
                    Button(ChartedMetric.weight.rawValue) {
                        selectedMetric = .weight
                    }
                }
                if hasReps {
                    Button(ChartedMetric.reps.rawValue) {
                        selectedMetric = .reps
                    }
                }
                if hasDistance {
                    Button(ChartedMetric.distance.rawValue) {
                        selectedMetric = .distance
                    }
                }
                if hasDuration {
                    Button(ChartedMetric.duration.rawValue) {
                        selectedMetric = .duration
                    }
                }
            } label: {
                Text(selectedMetric.rawValue)
                    .fieldButton()
                    .font(.callout)
            }
        }
        .workoutExerciseRow()
    }
    
    @ViewBuilder private func PersonalBestsSection(exerciseGroups: [ExerciseGroup]) -> some View {
        if !exerciseGroups.isEmpty {
            Section {
                PersonalBestWeightRow(exerciseGroups: exerciseGroups)
                PersonalBestRepsRow(exerciseGroups: exerciseGroups)
                PersonalBestDistanceRow(exerciseGroups: exerciseGroups)
                PersonalBestDurationRow(exerciseGroups: exerciseGroups)
            } header: {
                Text("Personal Bests")
                    .librarySectionHeader()
            }
        }
    }
    
    @ViewBuilder private func PersonalBestWeightRow(exerciseGroups: [ExerciseGroup]) -> some View {
        let best = exerciseGroups
            .reduce(into: []) { exercises, group in
                exercises.append(contentsOf: group.exercises)
            }
            .compactMap { $0.weight }
            .max()
        
        
        if let best = best {
            HStack {
                Text("Weight")
                    .fieldLabel()
                Spacer()
                Text(best.formatted())
                    .bold()
            }
            .workoutExerciseRow()
        }
    }
    
    @ViewBuilder private func PersonalBestRepsRow(exerciseGroups: [ExerciseGroup]) -> some View {
        let best = exerciseGroups
            .reduce(into: []) { exercises, group in
                exercises.append(contentsOf: group.exercises)
            }
            .compactMap { $0.reps }
            .max()
        
        
        if let best = best {
            HStack {
                Text("Reps")
                    .fieldLabel()
                Spacer()
                Text(best.formatted())
                    .bold()
            }
            .workoutExerciseRow()
        }
    }
    
    @ViewBuilder private func PersonalBestDistanceRow(exerciseGroups: [ExerciseGroup]) -> some View {
        let best = exerciseGroups
            .reduce(into: []) { exercises, group in
                exercises.append(contentsOf: group.exercises)
            }
            .compactMap { $0.distance }
            .max()
        
        
        if let best = best {
            HStack {
                Text("Distance")
                    .fieldLabel()
                Spacer()
                Text(best.formatted())
                    .bold()
            }
            .workoutExerciseRow()
        }
    }
    
    @ViewBuilder private func PersonalBestDurationRow(exerciseGroups: [ExerciseGroup]) -> some View {
        let best = exerciseGroups
            .reduce(into: []) { exercises, group in
                exercises.append(contentsOf: group.exercises)
            }
            .compactMap { $0.duration }
            .max()
        
        
        if let best = best {
            HStack {
                Text("Duration")
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
                Text("History")
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
