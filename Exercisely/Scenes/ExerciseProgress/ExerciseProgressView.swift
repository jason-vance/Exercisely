//
//  ExerciseProgressView.swift
//  Exercisely
//
//  Created by Jason Vance on 4/3/25.
//

import SwiftUI

//TODO: Release: Ability to choose exercise
//TODO: Chart metrics over time
//TODO: Show relevant data (PBs, growth rate, etc)
//TODO: Chart projected future progress
struct ExerciseProgressView: View {
    
    @State private var exerciseName: Workout.Exercise.Name? = nil
    
    var body: some View {
        VStack(spacing: 0) {
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
}

#Preview {
    NavigationStack {
        ExerciseProgressView()
    }
}
