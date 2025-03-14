//
//  AddExerciseView.swift
//  Exercisely
//
//  Created by Jason Vance on 3/13/25.
//

import SwiftUI

struct AddExerciseView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var workoutSection: Workout.Section
    
    @State private var name: Workout.Exercise.Name? = nil
    @State private var weight: Weight? = nil
    @State private var reps: Workout.Exercise.Reps? = nil
    @State private var distance: Distance? = nil
    @State private var time: Workout.Exercise.Duration? = nil
    

    private var exerciseToSave: Workout.Exercise? {
        guard let name = name else {
            return nil
        }
        
        let exercise = Workout.Exercise(
            name: name,
            weight: weight,
            reps: reps,
            distance: distance,
            time: time
        )
        
        guard let exercise = exercise else {
            return nil
        }
        
        return exercise
    }
    
    private func saveExercise() {
        guard let exercise = exerciseToSave else {
            print("Failed to create Exercise to save")
            return
        }
        
        workoutSection.append(exercise: exercise)
        dismiss()
    }
    
    var body: some View {
        List {
            Instructions()
            NameField()
            WeightField()
            RepsField()
            DistanceField()
            TimeField()
        }
        .listDefaultModifiers()
        .toolbar { Toolbar() }
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
    
    @ToolbarContentBuilder private func Toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Add Exercise")
                .bold(true)
                .foregroundStyle(Color.text)
        }
        ToolbarItem(placement: .topBarLeading) {
            CancelButton()
        }
        ToolbarItem(placement: .topBarTrailing) {
            SaveButton()
        }
    }
    
    @ViewBuilder private func CancelButton() -> some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(Color.accentColor)
        }
    }
    
    @ViewBuilder private func SaveButton() -> some View {
        Button {
            saveExercise()
        } label: {
            Image(systemName: "checkmark")
                .foregroundStyle(Color.accentColor)
        }
        .disabled(exerciseToSave == nil)
    }
    
    @ViewBuilder private func Instructions() -> some View {
        Section {
            Text("Add an exercise to the \"\(workoutSection.name)\" section of your workout. Enter the data from just your first set for now. You will be able to add more sets later.")
                .font(.caption)
                .workoutExerciseRow()
        }
    }
    
    @ViewBuilder private func NameField() -> some View {
        Section {
            NavigationLinkNoChevron {
                 ExerciseNameEditView(name: $name)
            } label: {
                Text(name?.formatted() ?? Workout.Exercise.Name.prompt.formatted())
                    .opacity(name == nil ? 0.35 : 1)
                    .bold()
                    .underlined()
            }
            .workoutExerciseRow()
        } header: {
            SectionHeader("Name")
        }
    }
    
    @ViewBuilder private func WeightField() -> some View {
        Section {
            Button {
                 
            } label: {
                Text(weight?.formatted() ?? "N/A")
            }
            .bold()
            .workoutExerciseRow()
            .underlined()
        } header: {
            SectionHeader("Weight")
        }
    }
    
    @ViewBuilder private func RepsField() -> some View {
        Section {
            Button {
                 
            } label: {
                Text(reps?.formatted() ?? "N/A")
            }
            .bold()
            .workoutExerciseRow()
            .underlined()
        } header: {
            SectionHeader("Reps")
        }
    }
    
    @ViewBuilder private func DistanceField() -> some View {
        Section {
            Button {
                 
            } label: {
                Text(distance?.formatted() ?? "N/A")
            }
            .bold()
            .workoutExerciseRow()
            .underlined()
        } header: {
            SectionHeader("Distance")
        }
    }
    
    @ViewBuilder private func TimeField() -> some View {
        Section {
            Button {
                 
            } label: {
                Text(time?.formatted() ?? "N/A")
            }
            .bold()
            .workoutExerciseRow()
            .underlined()
        } header: {
            SectionHeader("Time")
        }
    }
}

#Preview {
    NavigationStack {
        AddExerciseView(workoutSection: .sampleWorkout)
    }
}
