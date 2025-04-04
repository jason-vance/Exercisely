//
//  ExerciseProgressView.swift
//  Exercisely
//
//  Created by Jason Vance on 4/3/25.
//

import SwiftUI

//TODO: Release: Chart metrics over time
//TODO: Release: Show relevant data (PBs, growth rate, etc)
//TODO: Release: Show previous times doing the exercise as sets, dropsets, etc
//TODO: Chart projected future progress
struct ExerciseProgressView: View {
    
    @State private var exerciseName: Workout.Exercise.Name? = nil
    
    var body: some View {
        List {
            ExerciseNameField()
        }
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
}

#Preview {
    NavigationStack {
        ExerciseProgressView()
    }
}
